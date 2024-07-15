import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/views/customer_report_menu/const.dart';

import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/company_table_data.dart';
import '../../shared/input_field.dart';
import '../../styles/app_colors.dart';
import 'dsf_details.dart';

class dsf_detail_report extends StatefulWidget {
  String? year;
  String? month;
  String? Supervisor_id;
  String? name;
  String? monthnumber;

  dsf_detail_report({Key? key, this.year, this.Supervisor_id, this.month , this.name, this.monthnumber}) : super(key: key);
  @override
  State<dsf_detail_report> createState() => _fmsalesState();
}
hand heading = hand(
    companyName: "ID/""DSF Name", invCount: "Total Cus", totalSales: "UC's"
);
String? index;
List<hand> dataa = [];
DateFormat dateFormat = DateFormat('yyyy-MM-dd');
String? selectedMonth;
String? selectedyear;
bool isLoading=false;
class _fmsalesState extends State<dsf_detail_report> {
  Future<void> getSupervisorReportData(String a, String b, String c) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().dsf_details(
        context as BuildContext, a,b,c);


    print(response);
    print('Response Data:$response');
    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(
            companyName: '${element.dsf_id.toString()}-${element.dsf_name.toString()}',
            companyid: element.dsf_id.toString(),
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
    DateTime currentDate = DateTime.now();
    index = currentDate.month.toString().padLeft(2, '0');
    selectedyear=widget.year.toString();
    selectedMonth=widget.month.toString();
    index=widget.monthnumber;
   print("dsf details year: ${widget.monthnumber.toString()}");
  setState(() {
    selectedMonth=widget.month;
    selectedyear=widget.year;
  });
    getSupervisorReportData(widget.monthnumber.toString(),selectedyear.toString(),widget.Supervisor_id.toString());

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
        "DSF Detail Report",
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
                      getSupervisorReportData(index.toString(),selectedyear.toString(),widget.Supervisor_id.toString());
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
                          getSupervisorReportData(index.toString() , selectedyear.toString(),widget.Supervisor_id.toString());
                          print( index.toString());
                        });
                      }
                    },

                  )

              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: widget.name != null
                ? Text(
              widget.name.toString(),
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
                            dsf_details
                              (
                                code: companyid.toString(),
                                name: name,
                                month: selectedMonth.toString(),
                                year: selectedyear.toString(),
                                dsf_id:companyid.toString(),
                              countmonth:index.toString() ,
                            ))
                    );
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