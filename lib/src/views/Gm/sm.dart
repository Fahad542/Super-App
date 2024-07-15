

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/views/Gm/rsm.dart';
import 'package:premier/src/views/customer_report_menu/const.dart';

import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/company_table_data.dart';
import '../../shared/input_field.dart';
import '../../styles/app_colors.dart';

class sm extends StatefulWidget {

  final String month;
  final String month_number;
  final String year;
  final String id;
  final String name;

  const sm({Key? key, required this.month, required this.year, required this.id, required this.name, required this.month_number}) : super(key: key);

  @override
  State<sm> createState() => _dsf_company_wiseState();
}

class _dsf_company_wiseState extends State<sm> {
  bool isLoading = false;
  String? selectedMonth;
  String? selectedyear;
  String? index;
  hand heading = hand(
      companyName: "ID/"
          "SM Name", invCount: "Total Cust", totalSales: "UC's");
  List<hand> dataa = [];
  Future<void> getSalesReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().sm(context, a, b,widget.id);

    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(
          companyName:
          '${element.sm_id.toString()}-${element.sm_name.toString()}',
          invCount: element.total_customers.toString(),
          dsfid: element.sm_id.toString(),
          totalSales: element.total_ucs.toString(),
          companyid: element.sm_id.toString()
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

    getSalesReportData(widget.month_number, widget.year);
    setState(() {
      selectedyear=widget.year;
      index = widget.month_number.toString();
      selectedMonth= widget.month;
      selectedyear= widget.year;
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
        widget.name == '' ? "SM customer report" : widget.name,
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

                  SizedBox(
                    width: 170,
                    child: CustomDropDown(value: selectedMonth, items: custommonth.monthlist,  onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedMonth = newValue;
                        },

                        );
                      }

                    },
                      onIndexChanged: (int newIndex) {
                        setState(() {
                          index = (newIndex + 1).toString().padLeft(2, '0');
                          getSalesReportData(index.toString() , selectedyear.toString());
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
                              getSalesReportData(index.toString() , selectedyear.toString());
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
                    child:
                    handdetails(

                      heading: heading,
                      data: dataa,
                      onTap: (int value,
                          String name, String code) {

                        Navigator.push(context, MaterialPageRoute(builder: (context) => rsm(month: selectedMonth.toString(), year:selectedyear.toString(), id: value.toString(), name: name.toString(), month_number: index.toString(),)));
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