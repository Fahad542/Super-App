import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/views/customer_report_menu/const.dart';

import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/company_table_data.dart';
import '../../shared/DSF/supervisor_report.dart';
import '../../shared/input_field.dart';
import '../../styles/app_colors.dart';
import 'Dsf_detail_report.dart';
import 'dsf_details.dart';
import 'dsf_view.dart';

class supervisor_screen extends StatefulWidget {
  String? month_number;
  String? year;
  String? month;
  String? fm_id;
  String? fm_name;
   supervisor_screen({Key? key, this.month_number, this.year, this.fm_id, this.fm_name, this.month }) : super(key: key);
  @override
  State<supervisor_screen> createState() => _fmsalesState();
}
hand heading = hand(
    companyName: "Supervisor", invCount: "Total Cus", totalSales: "UC's"
);
List<hand> dataa = [];
String? selectedMonth;
String? selectedyear;
String? index;
DateFormat dateFormat = DateFormat('yyyy-MM-dd');

bool isLoading=false;
class _fmsalesState extends State<supervisor_screen> {
  Future<void> getSupervisorReportData(String a, String b, String c) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().supervisor_customer(
        context as BuildContext, a,b,c);


    print(response);
    print('Response Data:$response');
    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(
            companyName: '${element.supervisor_id.toString()}-${element.supervisor_name.toString()}',
            companyid: element.supervisor_id.toString(),
            invCount: element.total_customers.toString(),
            totalSales: element.total_ucs.toString()
        )
        );
      }
      );
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
setState(() {
  DateTime currentDate = DateTime.now();
  index = currentDate.month.toString().padLeft(2, '0');
  selectedyear=widget.year.toString();
  selectedMonth=widget.month.toString();
  index=widget.month_number;
  print("month:${widget.month.toString()}");
});
    getSupervisorReportData(index.toString(),widget.year.toString(),widget.fm_id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: new Icon(Icons.arrow_back),
          color: Colors.white),
      backgroundColor: AppColors.primary,
      title: Text(
      "Supervisor Screen",
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
          : Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 170,
                child: CustomDropDown(value: selectedMonth, items: custommonth.monthlist,  onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedMonth = newValue;
                      // Handle the selected year as needed
                    },
                    );
                  }

                },
                  onIndexChanged: (int newIndex) {
                    setState(() {
                      index = (newIndex + 1).toString().padLeft(2, '0');
                      getSupervisorReportData(index.toString(),selectedyear.toString(),widget.fm_id.toString());
                      print(index);
                    });
                  },

                ),
              ),
              SizedBox(width: 10,),
              SizedBox(
                  width: 120,
                  child: CustomDropDown(
                    value: selectedyear,
                    items: customyear.yearlist, // Replace with your actual list of years
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedyear = newValue;
                          getSupervisorReportData(index.toString() , selectedyear.toString(),widget.fm_id.toString());
                          print( index.toString());
                          print(selectedyear);
                        });
                      }
                    },
                  )
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: widget.fm_name != null
                ? Text(
              widget.fm_name.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
                : SizedBox(), // Hides the Text widget if widget.fm_name is null
          ),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SingleChildScrollView(
                child: handdetails(
                  heading: heading,
                  data: dataa,
                  onTap: (int companyid, String name, String amount) {
                    // Constants.customErrorSnack(context, "No Record Found");
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                           dsf_detail_report(
                             name: name,
                             Supervisor_id: companyid.toString(),
                             year: selectedyear.toString(),
                             month: selectedMonth.toString(),
                             monthnumber: index,

                           ),


                    )

                    );
                    print("Supervisor Screen year: $index");
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