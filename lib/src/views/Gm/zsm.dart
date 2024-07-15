import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/views/customer_report_menu/const.dart';
import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/company_table_data.dart';
import '../../shared/input_field.dart';
import '../../styles/app_colors.dart';
import '../customer_report_menu/Customer_report/customer_report.dart';
import 'azsm.dart';

class zsm extends StatefulWidget {

  final String month;
  final String year;
  final String id;
  final String name;
  final String month_number;

  const zsm({Key? key, required this.month, required this.year, required this.id, required this.name, required this.month_number}) : super(key: key);

  @override
  State<zsm> createState() => _dsf_company_wiseState();
}

class _dsf_company_wiseState extends State<zsm> {
  bool isLoading = false;
  hand heading = hand(
      companyName: "ID/"
          "ZSM Name", invCount: "Total Cust", totalSales: "UC's"

  );
  List<hand> dataa = [];
  Future<void> getSalesReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().zsm(context, a, b,widget.id);

    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(
          companyName:
          '${element.zsm_id.toString()}-${element.zsm_name.toString()}',
          invCount: element.total_customers.toString(),
          dsfid: element.zsm_id.toString(),
          companyid: element.zsm_id.toString(),
          totalSales: element.total_ucs.toString(),

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

    getSalesReportData(widget.month_number,widget.year);
    setState(() {
      selectedyear=widget.year;
      index=widget.month_number.toString();
      selectedMonth= widget.month;
      selectedyear= widget.year;
    });

    // TODO: implement initState
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
        widget.name.isEmpty ? "ZSM Customer Report" :widget.name,
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
                          // Handle the selected year as needed
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
                      onTap: (int value, String name,String code) {
                        print("company: ${heading.dsfid}");
                        print(value);
                        print(name);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => azsm( month: selectedMonth.toString(), year: selectedyear.toString(),
                          month_number: index.toString(), id: value.toString(), name: name

                          ,)));

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