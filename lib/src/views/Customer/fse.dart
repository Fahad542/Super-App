import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/shared/DSF/supervisor_report.dart';
import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/Datecontainers.dart';
import '../../shared/DSF/company_table_data.dart';
import '../../shared/DSF/fm_company.dart';
import '../../styles/app_colors.dart';

class fse_sale extends StatefulWidget {

  final String startdate;
  final String enddate;
  final String id;
  final String name;
  final int check ;

  const fse_sale({Key? key, required this.id, required this.name, required this.startdate, required this.enddate, required this.check}) : super(key: key);

  @override
  State<fse_sale> createState() => _dsf_company_wiseState();
}

class _dsf_company_wiseState extends State<fse_sale> {
  bool isLoading = false;
  String? selectedMonth;
  String? selectedyear;
  String formattedStartDate='';
  String formattedEndDate='';
  DateTime? startDates;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? endDates;
  String? index;
  List<branches> branchlist = [];

  hand heading = hand(
      companyName: "ID/""FSE Name", invCount: "Total Inv", totalSales: "Sale Amt");
  List<hand> dataa = [];
  Future<void> getSalesReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().fsereport(context, a, b,widget.id);

    response?.when(success: (_s) async {
      dataa.clear();
      branchlist.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(

          companyName: '${element.fse_id.toString()}-${element.fse_name.toString()}',
          brname: element.fse_brname.toString(),
          invCount: element.total_invoices.toString(),
          totalSales: element.total_saleamount.toString(),
          dsfid: element.fse_id.toString(),
          companyid: element.fse_id.toString(),
          name: element.branchwisedetail!.map((branch) => branch.branch_name.toString()).toList(),
          sale: element.branchwisedetail!.map((branch) => branch.saleamount.toString()).toList(),
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
  @override
  void initState() {
    print("startdate: ${widget.startdate}");
    print("enddate: ${widget.enddate}");
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
        widget.name.isEmpty ?"FSE Sale Report" :widget.name,
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
                      brcheck: true,
                      branchs: branchlist,
                      heading: heading,
                      data: dataa,
                      onTap: (int companyid, String name, String amount) {
                        ;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => widget.check == 1
                                ? fm_company(
                              startdate: formattedStartDate,
                              enddate: formattedEndDate,
                              dsfcompanyName: name,
                              companyid: companyid.toString(),
                            )
                                : supervisorreport(
                              startdate: formattedStartDate,
                              enddate: formattedEndDate,
                              id: companyid.toString(),
                              name: name,
                               amount: '',
                            ),
                          ),

                        );
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