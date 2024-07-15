import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/shared/DSF/zm_dsf.dart';

import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../styles/app_colors.dart';
import 'Datecontainers.dart';
import 'company_table_data.dart';

class supervisorreport extends StatefulWidget {
  final String id;
  final String name;
  final String amount;
  final String startdate;
  final String enddate;
  const supervisorreport({Key? key, required this.id, required this.name,required this.amount,required this.startdate, required this.enddate}) : super(key: key);

  @override
  State<supervisorreport> createState() => _fmsalesState();
}
hand heading = hand(
    companyName: "ID/"
        "Supervisor Name", invCount: "Invoices", totalSales: "Amount");
List<hand> dataa = [];
DateFormat dateFormat = DateFormat('yyyy-MM-dd');
DateTime? startDates;
DateTime? endDates;
String formattedStartDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
String formattedEndDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
bool isLoading=false;
class _fmsalesState extends State<supervisorreport> {
  Future<void> getSalesReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().supervisorsalesreport(context as BuildContext, a, b,widget.id);


    print(response);
    print('Response Data:$response');
    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(

          brname: element.supervisor_branchname.toString(),
          companyName:'${element.supervisor_id.toString()}-${element.supervisor_name.toString()}',
          companyid: element.supervisor_id.toString(),
          invCount: element.totalInvoices.toString(),
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
startDates=DateTime.parse(widget.startdate);
endDates=DateTime.parse(widget.enddate);
    getSalesReportData(startDates.toString(),endDates.toString());

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
        widget.name,
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
              DateContainer(title: "Start Date",
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
                        getSalesReportData(startDates.toString(), endDates.toString());
                      } else {
                        // Handle the case where formattedStartDate is greater than formattedEndDate
                        Constants.customErrorSnack(context, "Start date should be less than or equal to End date");
                      }


                      // show = true;
                    });
                  }

              ),






              DateContainer(title: "End Date",
                  selectedDate: endDates,
                  range: widget.enddate,
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
                        getSalesReportData(startDates.toString(), endDates.toString());
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
                  brcheck: true,
                  heading: heading,
                  data:dataa ,
                  onTap: (int companyid, String name, String amount) {

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            zm_dsf(id: companyid.toString(),
                                name: name,
                                amount: amount,
                                startdate: startDates.toString(),
                                enddate: endDates.toString())));

                  }
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
