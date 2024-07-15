import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/views/Gm/ssm.dart';
import 'package:premier/src/views/customer_report_menu/const.dart';
import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/company_table_data.dart';
import '../../shared/input_field.dart';
import '../../styles/app_colors.dart';

class gm extends StatefulWidget {

  final String month;
  final String year;

  const gm({Key? key, required this.month, required this.year}) : super(key: key);

  @override
  State<gm> createState() => _dsf_company_wiseState();
}

class _dsf_company_wiseState extends State<gm> {
  bool isLoading = false;
  String? selectedMonth;
  String? selectedyear;
  String? index;

  hand heading = hand(
      companyName: "ID/"
          "Gm Name", invCount: "Total Cust", totalSales: "UC's");
  List<hand> dataa = [];
  Future<void> getSalesReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().gmreport(context, a, b);

    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(
          companyName: '${element.gm_id.toString()}-${element.gm_name.toString()}',
          invCount: element.total_customers.toString(),
          totalSales: element.total_ucs.toString(),
          dsfid: element.gm_id.toString(),
          companyid: element.gm_id.toString(),


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
    DateTime currentDate = DateTime.now();
    index = currentDate.month.toString().padLeft(2, '0');
    selectedyear=widget.year;
    getSalesReportData(index.toString(),widget.year);
    setState( () {
      selectedMonth= widget.month;
      selectedyear= widget.year;
    }
    );
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
       "GM Customer Report",
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
                          print("selected month${index.toString()} selected year${selectedyear}");
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
                              print("selected month${index.toString()} selected year${selectedyear}");
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
                          onTap: (int companyid, String name, String amount) {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => ssm( month_number: index.toString(),month: selectedMonth.toString(), year: selectedyear.toString(), id: companyid.toString(),name: name.toString(),)));
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