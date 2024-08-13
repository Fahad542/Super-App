import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/services/remote/api_result.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:premier/src/shared/DSF/FM_company_sales_report.dart';
import 'package:premier/src/shared/DSF/FM_sales_report.dart';
import 'package:premier/src/shared/DSF/salesreport.dart';
import 'package:premier/src/views/Customer/fse.dart';
import 'package:premier/src/views/Customer/rsm_sale_report.dart';
import 'package:premier/src/views/Customer/ssm_sale.dart';
import 'package:premier/src/views/Customer/zsm_sale.dart';
import 'package:premier/src/views/Gm/azsm.dart';
import 'package:premier/src/views/Gm/fse.dart';
import 'package:premier/src/views/Gm/zsm.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import '../../models/version_model.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/company_sale_report.dart';
import '../../shared/DSF/fm_company.dart';
import '../Customer/azsm.dart';
import '../Customer/gm_sale.dart';
import '../Customer/sm_sale_report.dart';
import '../Gm/gm_report.dart';
import '../Gm/rsm.dart';
import '../Gm/sm.dart';
import '../Gm/ssm.dart';
import '../customer_report_menu/Customer_report/customer_report.dart';
import '../customer_report_menu/Dsf_detail_report.dart';
import '../customer_report_menu/supervisor_report_screen.dart';
import '../geo_coordinates/geo_coordinates.dart';

class ItemCard {
  final String key;
  final String name;
  final String icon;
  final bool isActive;

  ItemCard(
      {required this.key,
      required this.isActive,
      required this.name,
      required this.icon});
}

class DashboardViewModel extends ReactiveViewModel
    with AuthViewModel, ApiViewModel {
  List<ItemCard> items = [];
  List<ItemCard> upcomingItems = [];
  int selectedIndex = 0;
  ApiResult<VersionModel>? res;
  String? imageUrl = "";
  File? pickedImage;
  Uint8List webImage = Uint8List(8);
  late final Cloudinary cloudinary;
  String version = '';
  String apiversion = '';
  List<VersionModel> dataa = [];
  bool updateSuccessful = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late Version localVersion;
  late Version apiVersion;



  init(BuildContext context) async {
    await _firebaseMessaging.requestPermission();
    String token = await _firebaseMessaging.getToken() ?? "";
    try {
      var versionResult = await ApiService().version(context,token);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
      print("App Version: $version");

      if (versionResult != null) {
        versionResult.when(
          success: (data) {
            // Successfully received the version response
            var versionModel = data;
            print("API Version: ${versionModel.data![0].versionNo}");
            apiversion = versionModel.data![0].versionNo;

            if (versionModel != null &&
                versionModel.data != null &&
                versionModel.data!.isNotEmpty) {
              // Parse version numbers to integers

              localVersion = Version.parse(version);
              apiVersion = Version.parse(versionModel.data![0].versionNo);

              // Compare the versions
              if (localVersion < apiVersion) {
                print('Showing update alert');
                showUpdateAlert(context);
              }
            }
          },
          failure: (error) {
            // Handle the case where the request was not successful
            print('Failed to get version response. Error: $error');
          },
        );
      }
    } catch (e) {
      // Handle exceptions that might occur during the API call
      print('Error during version API call: $e');
    }

    cloudinary = Cloudinary.signedConfig(
      apiKey: "437822198458896",
      apiSecret: "lbKwyoUzq5XZjNI4QKe4NS2LN4s",
      cloudName: "dcy1afevz",
    );
    checkForUpdate();
    authService.user?.menuData
        ?.where((element) =>
            element.status == "Yes" || element.status == "Upcoming")
        .forEach((element) {
      items.add(ItemCard(
          name: element.name.toString(),
          icon: element.icon.toString(),
          isActive: (element.status == "Yes"),
          key: element.key.toString()));
    });
    if (authService.user?.data?.image == null) {
      try {
        String _path =
            "https://res.cloudinary.com/dcnrpf85i/image/upload/v1677132320/PremierSuperApp/${authService.user?.data?.userId}.png";
        validateImage(_path).then((value) {
          if (value == true) {
            imageUrl = _path;
            authService.user?.data?.image = _path;
            notifyListeners();
          } else {
            authService.user?.data?.image = null;
            notifyListeners();
          }
        });
        await CachedNetworkImage.evictFromCache(_path);
      } catch (e) {
        print(e);
      }
    } else {
      imageUrl = authService.user?.data?.image;
    }
  }

  pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = File(image.path);
      webImage = await image.readAsBytes();
      await _uploadImage();
      notifyListeners();
    }
  }

  Future<bool> validateImage(String imageUrl) async {
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return _checkIfImage(data['content-type']);
  }

  static bool _checkIfImage(String param) {
    if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
      return true;
    }
    return false;
  }

  _uploadImage() async {
    try {
      String fileName = authService.user?.data?.userId ?? "0";
      final cloudResponse = await cloudinary.upload(
        file: pickedImage?.path ?? "",
        fileBytes: webImage,
        resourceType: CloudinaryResourceType.image,
        folder: "PremierSuperApp",
        fileName: fileName,
        progressCallback: (count, total) {},
      );
      imageUrl = cloudResponse.secureUrl;
      authService.user?.data?.image = imageUrl;
    } catch (e) {
      print(e);
    }
  }

  NavService? getNavigatorByItem(String item, BuildContext context) {
    switch (item) {
      case "DSF":
        {
          NavService.dSF();
        }
        break;
      case "ROUTE":
        {
          NavService.route();
        }
        break;
      case "SUPERVISOR":
        {
          NavService.supervisorDashboard();
        }

        break;
      case "CUSTOMERREPORT":
        DateTime now = DateTime.now();
        String currentMonth = DateFormat('MMMM').format(DateTime.now());
        int currentYear = now.year;
        {

          if (authService.user?.data?.loginType == "Zonal_Manager"
             // authService.user?.data?.loginType == "Field_Manager"


          ) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => zsm(name: '', id: '', month: currentMonth.toString(), year: currentYear.toString(), month_number: '',)));
          }
          if (authService.user?.data?.loginType == "Field_Manager"
          // authService.user?.data?.loginType == "Field_Manager"


          ) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => customer_report(name: '', month: currentMonth.toString(), year: currentYear.toString(), month_number: '',)));
          }


          else if (authService.user?.data?.loginType == "DSF_Supervisor") {


            // Extract current month and year

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => supervisor_screen(
                          fm_id: "",
                          month: currentMonth.toString(),
                          year: currentYear.toString(),
                          month_number: '',
                        )));
          } else if (authService.user?.data?.loginType == "DSF") {
            DateTime now = DateTime.now();

            // Extract current month and year
            String currentMonth = DateFormat('MMMM').format(DateTime.now());
            int currentYear = now.year;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => dsf_detail_report(
                          Supervisor_id: "",
                          month: currentMonth.toString(),
                          year: currentYear.toString(),
                          monthnumber: '',
                        )));
          } else if (authService.user?.data?.loginType ==
              "Chief_Executive_Officer") {
            DateTime now = DateTime.now();
            String currentMonth = DateFormat('MMMM').format(DateTime.now());
            int currentYear = now.year;
            print("object");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => gm(
                          month: currentMonth,
                          year: currentYear.toString(),
                        )));
          } else if (authService.user?.data?.loginType ==
              "Chief_Executive_Officer") {
            DateTime now = DateTime.now();
            String currentMonth = DateFormat('MMMM').format(DateTime.now());
            int currentYear = now.year;
            print("object");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => gm(
                          month: currentMonth,
                          year: currentYear.toString(),
                        )));
          } else if (authService.user?.data?.loginType == "General_Manager") {
            DateTime now = DateTime.now();
            String currentMonth = DateFormat('MMMM').format(DateTime.now());
            int currentYear = now.year;
            print("object");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => gm(
                          month: currentMonth,
                          year: currentYear.toString(),
                        )));
          } else if (authService.user?.data?.loginType ==
              "Senior_Sales_Manager") {
            DateTime now = DateTime.now();
            int currentMonthNumber = DateTime.now().month;
            String formattedMonth =
                currentMonthNumber.toString().padLeft(2, '0');

            // Output: "04" for April

            String currentMonth = DateFormat('MMMM').format(DateTime.now());

            int currentYear = now.year;
            print("object");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ssm(
                          month: currentMonth,
                          year: currentYear.toString(),
                          id: '',
                          name: '',
                          month_number: formattedMonth.toString(),
                        )));
          } else if (authService.user?.data?.loginType == "Sales_Manager") {
            DateTime now = DateTime.now();
            int currentMonthNumber = DateTime.now().month;
            String formattedMonth =
                currentMonthNumber.toString().padLeft(2, '0');
            String currentMonth = DateFormat('MMMM').format(DateTime.now());

            int currentYear = now.year;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => sm(
                          month: currentMonth,
                          year: currentYear.toString(),
                          id: '',
                          name: '',
                          month_number: formattedMonth.toString(),
                        )));
          } else if (authService.user?.data?.loginType ==
              "Regional_Sales_Manager") {
            DateTime now = DateTime.now();
            int currentMonthNumber = DateTime.now().month;
            String formattedMonth =
                currentMonthNumber.toString().padLeft(2, '0');
            String currentMonth = DateFormat('MMMM').format(DateTime.now());

            int currentYear = now.year;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => rsm(
                          month: currentMonth,
                          year: currentYear.toString(),
                          id: '',
                          name: '',
                          month_number: formattedMonth.toString(),
                        )));
          }


          else if (authService.user?.data?.loginType ==
              "Assistant_Zonal_Manager") {
            DateTime now = DateTime.now();
            int currentMonthNumber = DateTime
                .now()
                .month;
            String formattedMonth =
            currentMonthNumber.toString().padLeft(2, '0');
            String currentMonth = DateFormat('MMMM').format(DateTime.now());

            int currentYear = now.year;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        azsm(
                          month: currentMonth,
                          year: currentYear.toString(),
                          id: '',
                          name: '',
                          month_number: formattedMonth.toString(),
                        )));
          }
          else if (authService.user?.data?.loginType ==
              "Field_Sales_Executive") {
            DateTime now = DateTime.now();
            int currentMonthNumber = DateTime
                .now()
                .month;
            String formattedMonth =
            currentMonthNumber.toString().padLeft(2, '0');
            String currentMonth = DateFormat('MMMM').format(DateTime.now());

            int currentYear = now.year;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        fse(
                          month: currentMonth,
                          year: currentYear.toString(),
                          id: '',
                          name: '',
                          month_number: formattedMonth.toString(),
                        )));
          }

        }
        break;
      case "GCREQUEST":
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => geo_coordinates()));
        }

        break;
      case "SALEREPORT":
        {
          String formattedStartDate =
              '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
          String formattedEndDate =
              '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
          if (authService.user?.data?.loginType == "Zonal_Manager") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => zsm_sale(
                      name: '',
                      startdate: formattedStartDate,
                      enddate: formattedEndDate,
                      id: '', check: 0,

                    )));
          } else if (authService.user?.data?.loginType ==
              "Chief_Executive_Officer") {  print("startdate: ${formattedStartDate} enddate: ${formattedEndDate}");



          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => gm_sale(startdate: formattedStartDate, enddate: formattedEndDate, check: 0,

                  ))

          );

          } else if (authService.user?.data?.loginType == "General_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => gm_sale(startdate: formattedStartDate, enddate:formattedEndDate, check: 0,
                    )));
          } else if (authService.user?.data?.loginType ==
              "Senior_Sales_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ssm_sale(

                      id: '',
                      name: '', startdate: formattedStartDate, enddate: formattedEndDate, check: 0,
                    )));
          } else if (authService.user?.data?.loginType ==
              "Regional_Sales_Manager") {


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => rsm_sale(

                      id: '',
                      name: '', startdate: formattedStartDate, enddate: formattedEndDate, check: 0,

                    )));
          } else if (authService.user?.data?.loginType == "Sales_Manager") {


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => sm_sale(enddate: formattedEndDate, id: '', startdate: formattedStartDate, name: '', check: 0,

                    )));
          } else if (authService.user?.data?.loginType == "Field_Manager") {
            DateTime now = DateTime.now();


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => fmcompanysales(
                      zsm_id: '',
                      name: '', startdate: formattedStartDate, enddate:formattedEndDate, check: 0,
                    )));
          } else if (authService.user?.data?.loginType == "Field_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => fmcompanysales(
                      zsm_id: '',
                      name: '', startdate:formattedStartDate, enddate: formattedEndDate, check: 0,
                    )));
          } else if (authService.user?.data?.loginType == "DSF_Supervisor") {


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => fm_company(
                      dsfcompanyName: '',
                      startdate: formattedStartDate,
                      enddate: formattedEndDate,
                      companyid: '',
                    )));
          } else if (authService.user?.data?.loginType == "Sales_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => sm_sale(

                      id: '',
                      name: '', enddate: formattedendDate, startdate: formattedStartDate, check: 0,

                    )));
          }
          else if (authService.user?.data?.loginType == "General_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => gm_sale(startdate: formattedStartDate, enddate:formattedEndDate, check: 0,
                    )));
          }
          else if (authService.user?.data?.loginType == "Field_Sales_Executive") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => fse_sale(startdate: formattedStartDate, enddate:formattedEndDate, check: 0, id: '', name: '',
                    )));
          }
          else if (authService.user?.data?.loginType == "Assistant_Zonal_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => azsm_sale(startdate: formattedStartDate, enddate:formattedEndDate, check: 0, id: '', name: '',
                    )));
          }

        }
        break;
      case "COMPANYSALEREPORT":
        {
          String formattedStartDate =
              '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
          String formattedEndDate =
              '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
          if (authService.user?.data?.loginType == "Zonal_Manager") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => zsm_sale(
                          name: '',
                          startdate: formattedStartDate,
                          enddate: formattedEndDate,
                          id: '', check: 1,

                        )));
          } else if (authService.user?.data?.loginType ==
              "Chief_Executive_Officer") {  print("startdate: ${formattedStartDate} enddate: ${formattedEndDate}");



            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => gm_sale(startdate: formattedStartDate, enddate: formattedEndDate, check: 1,

                        ))

            );

          } else if (authService.user?.data?.loginType == "General_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => gm_sale(startdate: formattedStartDate, enddate:formattedEndDate, check: 1,
                        )));
          } else if (authService.user?.data?.loginType ==
              "Senior_Sales_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ssm_sale(

                          id: '',
                          name: '', startdate: formattedStartDate, enddate: formattedEndDate, check: 1,
                        )));
          } else if (authService.user?.data?.loginType ==
              "Regional_Sales_Manager") {


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => rsm_sale(

                          id: '',
                          name: '', startdate: formattedStartDate, enddate: formattedEndDate, check: 1,

                        )));
          } else if (authService.user?.data?.loginType == "Sales_Manager") {


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => sm_sale(enddate: formattedEndDate, id: '', startdate: formattedStartDate, name: '', check: 1,

                        )));
          } else if (authService.user?.data?.loginType == "Field_Manager") {
            DateTime now = DateTime.now();


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => fmcompanysales(
                          zsm_id: '',
                          name: '', startdate: formattedStartDate, enddate:formattedEndDate, check: 1,
                        )));
          } else if (authService.user?.data?.loginType == "Field_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => fmcompanysales(
                          zsm_id: '',
                          name: '', startdate:formattedStartDate, enddate: formattedEndDate, check: 1,
                        )));
          } else if (authService.user?.data?.loginType == "DSF_Supervisor") {


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => fm_company(
                          dsfcompanyName: '',
                          startdate: formattedStartDate,
                          enddate: formattedEndDate,
                          companyid: '',

                        )));
          } else if (authService.user?.data?.loginType == "Sales_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => sm_sale(

                          id: '',
                          name: '', enddate: formattedendDate, startdate: formattedStartDate, check: 1,

                        )));
          }
          else if (authService.user?.data?.loginType == "Assistant_Zonal_Manager") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => azsm_sale(startdate: formattedStartDate, enddate:formattedEndDate, check: 0, id: '', name: '',
                    )));
          }
          else if (authService.user?.data?.loginType == "Field_Sales_Executive") {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => fse_sale(startdate: formattedStartDate, enddate:formattedEndDate, check: 0, id: '', name: '',
                    )));
          }

        }
        break;
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().then((value) {
          if (value != AppUpdateResult.success) {
            checkForUpdate();
          }
        });
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  bool isShowPassword = false;
  bool isShowRePassword = false;
  TextEditingController password = TextEditingController();
  TextEditingController rePassword = TextEditingController();

  onChangePassword(BuildContext context, BuildContext ctx) {
    if (m.Form.of(ctx)!.validate() && (password.text == rePassword.text)) {
      changePassword(context);
    }
  }

  Future<void> changePassword(BuildContext context) async {
    var newsResponse = await runBusyFuture(
        apiService.changePassword(context, password.value.text.trim()));
    newsResponse.when(success: (data) async {
      if (data) {
        password.clear();
        rePassword.clear();
      }
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }

  void showUpdateAlert(BuildContext context) async {
    bool updateSuccessful = false; // Track whether the update was successful

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Override the back button behavior
            return false; // Return false to indicate that the back button press is handled manually
          },
          child: AlertDialog(
            title: Text('Update Available'),
            content: Text(
                'A new version($apiversion) of the app is available. And your current version is($localVersion). Please update to the latest version.'),
            actions: [
              TextButton(
                onPressed: () async {
                  // Attempt to launch the Google Play Store URL
                  await launch(
                      'https://play.google.com/store/apps/details?id=com.premier.superapp');

                  if (localVersion == apiVersion) {
                    Navigator.of(context)
                        .pop(); // Close the dialog only if the update was successful
                  }
                },
                child: Text('Update Now'),
              ),
            ],
          ),
        );
      },
    );
  }
}
