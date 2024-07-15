import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/services/remote/api_service.dart';
import 'package:premier/src/shared/DSF/Datecontainers.dart';
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:premier/src/shared/DSF/dsf_company_wise.dart';
import 'package:premier/src/styles/app_colors.dart';
import '../../base/utils/Constants.dart';

class SalesReport extends StatefulWidget {

  const SalesReport({Key? key}) : super(key: key);

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  bool isLoading = false;
  bool generate=false;
  List<Widget> widgets = [];
  bool show = false;

  CompanyTableDatahand heading = CompanyTableDatahand(
      companyName: "DSF ID/Name", invCount: "Invoices", totalSales: "Amount");
  //SupervisorData superheading = SupervisorData(SupervisorName: "SupervisorName",);
  String totalInv = "0";
  String totalAmount = "0";
  DateTime? startDates;
  DateTime? endDates;
  DateTime? selectedDateFormat;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String formattedStartDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
  String formattedEndDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
  TextEditingController selectedDate = TextEditingController();
  List<CompanyTableDatahand> dataa = [];
  List<SupervisorData> supervisordataa = [];
  String selectedSupervisorName='Select Supervisor';
  String id="";
  String code='';

  Future<void> getSalesReportData(String a, String b, String c, String d) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().salesreportDsf(
        context,
        formattedStartDate,
        formattedEndDate,
        c,d
    );
    print(response);
    print('Response Data:$response');
    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(CompanyTableDatahand(

            companyName:'${element.dsfCode.toString()}-${element.dsfName.toString()}',
            invCount: element.totalInvoices.toString(),
            totalSales: element.totalSaleamount.toString(),
            dsfid: element.dsfId.toString(),

        )
        );

      });
      setState(() {
        isLoading = false;
      });
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
      setState(() {
        isLoading = false;
      });
    });
  }
  ///////////////////
  Future<void> Supervisorlist() async {
    setState(() {
      isLoading = true;
    });
    var responses = await ApiService().supervisorList(context,"");
    print(responses);
    print('Response Data:$responses');
    responses?.when(success: (_d) async {
      supervisordataa.clear();

      _d.superdata?.forEach((element) {
        supervisordataa.add( SupervisorData(SupervisorName: element.supervisor_name, SupervisorId: element.supervisor_id, SupervisorCode: element.supervisor_code, branch: element.supervisor_branch)
        );
      });
      setState(() {
        isLoading = false;
      });
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
      setState(() {
        isLoading = false;
      });
    });
  }
    @override
    void initState() {
      getSalesReportData(formattedStartDate, formattedEndDate, id,code);
      print("id: $id");
      print("code: $code");
      Supervisorlist();
      // TODO: implement initState
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return
        Scaffold(
        appBar:
        AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: new Icon(Icons.arrow_back),
              color: Colors.white),
          backgroundColor: AppColors.primary,
          title: Text(
            'DSF Sales Report',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        body:

        isLoading == true
            ?


        Container(
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        )
            :
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: [

                      SupervisorDatadropdown(

                        selectedSupervisor:selectedSupervisorName,
                        data: supervisordataa,
                        onTap: (selectedName, selectedid, selectedbranch) {
                          setState(() {
                            //print(selectedSupervisorName);
                            selectedSupervisorName = selectedName;
                            id = selectedid;
                            code=selectedbranch;
                            getSalesReportData(formattedStartDate,
                                formattedEndDate, id, code);
                          }  );}),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  DateContainer(
                                      title: "Start Date",
                                      selectedDate: startDates,

                                      range: formattedStartDate,
                                      onDateSelected: (range) {
                                        setState(() {
                                          startDates = range;
                                          formattedStartDate = dateFormat.format(
                                              startDates ?? range);});
                                        setState(() {
                                          if (formattedStartDate != null &&
                                              formattedEndDate != null &&
                                              formattedStartDate.compareTo(formattedEndDate) <= 0) {
                                            getSalesReportData(formattedStartDate, formattedEndDate, id, code);
                                          } else {
                                            // Handle the case where formattedStartDate is greater than formattedEndDate
                                            Constants.customErrorSnack(context, "Start date should be less than or equal to End date");
                                          }

                                          print("Start date");
                                            print(formattedStartDate);
                                            print(formattedEndDate);
                                          show = true;
                                        });
                                      }

                                  ),

                                  DateContainer(
                                      title: "End Date",
                                      selectedDate: endDates,
                                      range: formattedEndDate,
                                      onDateSelected: (range) {
                                        setState(() {
                                          endDates = range;
                                          formattedEndDate = dateFormat.format(
                                              endDates ?? DateTime.now());
                                        });
                                        setState(() {
                                          if (formattedStartDate != null &&
                                              formattedEndDate != null &&
                                              formattedStartDate.compareTo(
                                                  formattedEndDate) <= 0) {
                                            getSalesReportData(
                                                formattedStartDate,
                                                formattedEndDate, id, code);
                                          } else {
                                            Constants.customErrorSnack(context,
                                                "Start date should be less than or equal to End date");
                                          }
                                          print("End date");
                                          print(formattedStartDate);
                                          print(formattedEndDate);
                                          show = true;
                                        });
                                      }
                                      ),

                                ],
                              ),





                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(!show)
                            Text("Current Month Sale", style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),

                        ],),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CompanyDataTablehand(

                              heading: heading,
                              data: dataa,
                              onTap: (int value) {
                                print("company: ${heading.dsfid}");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => dsf_company_wise(dsfcompanyName: heading.dsfcompanyname.toString(),startdate: formattedStartDate,enddate: formattedEndDate,dsfid:value.toString(),)));
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      );
    }
  }

