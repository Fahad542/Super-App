import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/shared/DSF/supervisor_report.dart';
import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../styles/app_colors.dart';
import 'Datecontainers.dart';
import 'company_table_data.dart';
class fmsales extends StatefulWidget {
  const fmsales({Key? key}) : super(key: key);

  @override
  State<fmsales> createState() => _fmsalesState();
}
hand heading = hand(
    companyName: "ID/"
        "FM Name", invCount: "Invoices", totalSales: "Amount");
List<hand> dataa = [];
DateFormat dateFormat = DateFormat('yyyy-MM-dd');
DateTime? startDates;
DateTime? endDates;
String formattedStartDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
String formattedEndDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
bool isLoading=false;
class _fmsalesState extends State<fmsales> {
  Future<void> getSupervisorReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().fmsalesreport(context as BuildContext, a, b,"");


    print(response);
    print('Response Data:$response');
    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(
          companyName:'${element.fm_id.toString()}-${element.fm_name.toString()}',
          companyid: element.fm_id.toString(),
          invCount: element.totalInvoices.toString(),
         // start: element.start.toString(),,
          totalSales: element.totalSaleamount.toString(),


        )
        );

      });
      setState(() {
        isLoading = false;
      });
    }, failure: (error) {
      Constants.customErrorSnack(context as BuildContext, error.toString());
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  void initState() {

    startDates = DateTime(DateTime.now().year, DateTime.now().month, 1);
    endDates = DateTime.now();

    getSupervisorReportData(startDates.toString(),endDates.toString());
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(appBar: AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: new Icon(Icons.arrow_back),
          color: Colors.white),
      backgroundColor: AppColors.primary,
      title: Text(
        "FM Sales Report",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    ),
    body: isLoading == true
        ?


    Container(
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    )
        :   Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      getSupervisorReportData(formattedStartDate, formattedEndDate);
                    } else {
                      // Handle the case where formattedStartDate is greater than formattedEndDate
                      Constants.customErrorSnack(context, "Start date should be less than or equal to End date");
                    }

                    print("Start date");
                    print(formattedStartDate);
                    print(formattedEndDate);
                   // show = true;
                  });
                }

            ),



        //Column(children: [],),


            DateContainer(title: "End Date",
                selectedDate: endDates,
                range: formattedEndDate,
                onDateSelected: (range) {
                  setState(() {
                    endDates = range;
                    formattedEndDate = dateFormat.format(
                        endDates ?? DateTime.now());
                  });
                  //getSalesReportData();
                  setState(() {
                    if (formattedStartDate != null &&
                        formattedEndDate != null &&
                        formattedStartDate.compareTo(formattedEndDate) <= 0) {
                      getSupervisorReportData(formattedStartDate, formattedEndDate);
                    } else {

                      Constants.customErrorSnack(context, "Start date should be less than or equal to End date");
                    }

                    print("End date");
                    print(formattedStartDate);
                    print(formattedEndDate);
                    //show = true;
                  });
                }

            ),


          ],
        ),



        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: handdetails(
                heading: heading,
                data:dataa ,
                onTap: (int companyid, String name, String amount) {
                // Constants.customErrorSnack(context, "No Record Found");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => supervisorreport(id:companyid.toString(),name:name, amount: amount,startdate:startDates.toString(),enddate:endDates.toString())));
                  print(formattedStartDate);
                  print(formattedEndDate);

                },
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }
}
