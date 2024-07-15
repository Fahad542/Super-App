import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/views/Customer/sm_sale_report.dart';
import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/Datecontainers.dart';
import '../../shared/DSF/FM_company_sales_report.dart';
import '../../shared/DSF/company_table_data.dart';
import '../../styles/app_colors.dart';



class ssm_sale extends StatefulWidget {

  final String startdate;
  final String enddate;
  final String name;
  final String id;
  final int check;


  const ssm_sale({Key? key,required this.check, required this.startdate,required this.enddate, required this.name, required this.id}) : super(key: key);

  @override
  State<ssm_sale> createState() => _dsf_company_wiseState();
}

class _dsf_company_wiseState extends State<ssm_sale> {
  bool isLoading = false;
  String? selectedMonth;
  String? selectedyear;
  String? index;
  String formattedStartDate='';
  String formattedEndDate='';
  DateTime? startDates;
  DateTime? endDates;
  List<branches> branchlist = [];

  hand heading = hand(
      companyName: "ID/"
          "SSM Name", invCount: "Total Inv", totalSales: "Sale Amt");
  List<hand> dataa = [];
  Future<void> getSalesReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().ssmsalereport(context, a, b,widget.id);

    response?.when(success: (_s) async {
      dataa.clear();
      branchlist.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(
          companyName: '${element.ssm_id.toString()}-${element.ssm_name.toString()}',
          invCount: element.total_invoices.toString(),
          totalSales: element.total_saleamount.toString(),
          dsfid: element.ssm_id.toString(),
          companyid: element.ssm_id.toString(),
          name: element.branchwisedetail!.map((branch) => branch.branch_name.toString()).toList(),
          sale: element.branchwisedetail!.map((branch) => branch.saleamount.toString()).toList(),


        )


        );
        // if (element.branchwisedetail != null) {
        //   element.branchwisedetail!.forEach((branch) {
        //     branchlist.add(branches(
        //       saleamount: branch.saleamount,
        //       branch_code: branch.branch_code,
        //       branch_name: branch.branch_name,
        //     ));
        //   });
        // }

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
    DateTime currentDate = DateTime.now();
    index = currentDate.month.toString().padLeft(2, '0');

    getSalesReportData(widget.startdate,widget.enddate);
setState(() {
 formattedStartDate=widget.startdate;
 formattedEndDate=widget.enddate;
 String startdateString = widget.startdate.toString();
 startDates = DateTime.tryParse(startdateString);
 String enddateString = widget.enddate.toString();
 endDates = DateTime.tryParse(enddateString);
});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  appBar: AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: new Icon(Icons.arrow_back),
          color: Colors.white),
      backgroundColor: AppColors.primary,
      title: Text(
        widget.name.isEmpty ? "SSM Sale Report" : widget.name,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    ),
        body:   isLoading == true
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
          padding: const EdgeInsets.all(10),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DateContainer(
                      title: "Start Date",
                      selectedDate: startDates,

                      range: widget.startdate,
                      onDateSelected: (range) {
                        setState(() {
                          startDates = range;
                          formattedStartDate = dateFormat.format(
                              startDates ?? range);});
                        setState(() {
                          if (formattedStartDate != null &&
                              formattedEndDate != null &&
                              formattedStartDate.compareTo(formattedEndDate) <= 0) {
                            getSalesReportData(formattedStartDate,formattedEndDate);
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




                  DateContainer(
                      title: "End Date",
                      selectedDate: endDates,
                      range: widget.enddate,
                      onDateSelected: (range) {
                        setState(() {
                          endDates = range;
                          formattedEndDate = dateFormat.format(
                              endDates ?? range);
                        });
                        //getSalesReportData();
                        setState(() {
                          if (formattedStartDate != null &&
                              formattedEndDate != null &&
                              formattedStartDate.compareTo(formattedEndDate) <= 0) {
                            getSalesReportData(formattedStartDate,formattedEndDate);
                          } else {

                            Constants.customErrorSnack(context, "Start date should be less than or equal to End date");
                          }

                          print("End date");
                          print(formattedStartDate);
                          print(formattedEndDate);

                        });
                      }

                  ),


                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SingleChildScrollView(
                    child:
                    handdetails(
                      ischeck: true,
                      heading: heading,
                      branchs: branchlist,
                      data: dataa,
                      onTap: (int companyid, String name, String amount) {
                        ;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => sm_sale( id: companyid.toString(),name: name.toString(), enddate: formattedEndDate, startdate: formattedStartDate, check: widget.check,)));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        )

    );
  }
}