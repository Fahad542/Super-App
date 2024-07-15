import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/shared/input_field.dart';
import 'package:premier/src/views/customer_report_menu/const.dart';
import '../../../base/utils/Constants.dart';
import '../../../services/remote/api_service.dart';
import '../../../shared/DSF/company_table_data.dart';
import '../../../styles/app_colors.dart';
import '../../Gm/fse.dart';
import '../supervisor_report_screen.dart';

class customer_report extends StatefulWidget {
   String? zsm_id;
   String name;
   String? month;
   String? year;
   String? month_number;
   customer_report({Key? key, this.zsm_id,  this.year, this.month,  this.month_number, required this.name}) : super(key: key);
  @override
  State<customer_report> createState() => _fmsalesState();
  }
  hand heading = hand(
  companyName: "ID/""FM Name", invCount: "Total Cus", totalSales: "UC's",
  );
  List<hand> dataa = [];
  String? index;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? startDates;
  DateTime? endDates;
  String? selectedMonth;
  String? selectedyear;
  bool isLoading=false;

  class _fmsalesState extends State<customer_report> {
    Future<void> getSupervisorReportData(String a, String b) async {
      setState(() {
        isLoading = true;
      });
      var response = await ApiService().companyreport(
          context as BuildContext, a, b,widget.zsm_id.toString());



      response?.when(success: (_s) async {
        dataa.clear();
        _s.data?.forEach((element) {
          dataa.add(hand(


            companyName:'${element.fm_id.toString()}-${element.fm_name.toString()}',
            companyid: element.fm_id.toString(),
            totalSales: element.total_ucs.toString(),
            invCount: element.total_customers.toString(),
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
      if(widget.month==null && widget.year==null) {
        selectedMonth = custommonth.monthlist[currentDate.month -
            1]; // Adjusting for 0-based index
        selectedyear=widget.year;
        selectedyear = currentDate.year.toString();
        index = currentDate.month.toString().padLeft(2, '0');
        getSupervisorReportData(index.toString(),selectedyear.toString() );
      }
      else{
        getSupervisorReportData(index.toString(),widget.year.toString() );
        setState(() {
          selectedyear=widget.year;
          index=widget.month_number.toString();
          selectedMonth=widget.month;
          selectedyear=widget.year;
        });

      }

      print("selectedMonth: $selectedMonth");
      print("selectedyear: $selectedyear");
      print("year no: $index");

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
          widget.name.isEmpty ?"FM Customer Report" :widget.name,
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
                        getSupervisorReportData(index.toString() , selectedyear.toString());
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
                getSupervisorReportData(index.toString() , selectedyear.toString());
                print( index.toString());
                });
                }
                },

                  )

                )
                ],
            ),





            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SingleChildScrollView(
                  child: handdetails(
                    heading: heading,
                    data: dataa,
                    onTap: (int name, String id, String amount) {
                      print(name);
                      print(id);
                      print(amount);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => fse(

                            month_number: index.toString(),

                            year: selectedyear.toString(),
                            month: selectedMonth.toString(), id: name.toString(), name: id,
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
      );
    }
  }