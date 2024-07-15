import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../styles/app_colors.dart';
import 'Datecontainers.dart';
import 'FM_company_sales_report.dart';
import 'company_sale_report.dart';
import 'company_table_data.dart';

class fm_company extends StatefulWidget {
  final String dsfcompanyName;
  final String startdate;
  final String enddate;
  final String companyid;


  const fm_company({Key? key, required this.dsfcompanyName, required this.startdate, required this.enddate, required this.companyid}) : super(key: key);

  @override
  State<fm_company> createState() => _dsf_company_wiseState();
}

class _dsf_company_wiseState extends State<fm_company> {
  bool isLoading = false;
  CompanySales heading = CompanySales(
      companyName: "ID/"
          "Company Name", BookingInv: 'Booking Inv', ExecuteInv: 'ExecuteInv', ExecuteAmount: 'ExecuteAmount');
  DateTime? startDates;
  DateTime? endDates;
  List<CompanyTableData> dataa = [];
  List<SupervisorData> supervisordataa = [];
  String supervisorcode='';
  String supervisorbrach='';
  String selectedSupervisorName='Select Supervisor';
  String id="";
  String code='';
  Future<void> getSalesReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().FmCompanydsfsaledetail(context, a, b,widget.companyid);




    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(CompanyTableData(
          companyName:'${element.company_id.toString()}-${element.title.toString()}',
          companyid: element.company_id.toString(),
          invCount: element.totalInvoices.toString(),
          totalSales: element.totalSaleamount.toString(),
          dsfid: element.company_id.toString(),
          booking: element.booking_invoices.toString(),
          percent: element.execution_percentage.toString(),
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
  Future<void> Supervisorlist(String a) async {
    setState(() {
      isLoading = true;
    });
    var responses = await ApiService().supervisorList(context,a);
    print(responses);
    print('Response Data:$responses');
    responses?.when(success: (_d) async {
      supervisordataa.clear();

      _d.superdata?.forEach((element) {
        supervisordataa.add( SupervisorData(SupervisorName: element.supervisor_name, SupervisorId: element.supervisor_id, SupervisorCode: element.supervisor_code, branch: element.supervisor_branch)
        );
        supervisorcode=element.supervisor_code;
        supervisorbrach=element.supervisor_branch;

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
    Supervisorlist(widget.companyid);
    getSalesReportData(widget.startdate,widget.enddate);

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
        widget.dsfcompanyName.isEmpty ? "DSF Detail Report" : widget.dsfcompanyName,
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
              SupervisorDatadropdown(
                  selectedSupervisor:selectedSupervisorName,
                  data: supervisordataa,
                  onTap: (selectedName, selectedid, selectedbranch) {
                    setState(() {
                      print(selectedid);
                      print(selectedbranch);
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>companysale(name: selectedName, id: selectedid,code: selectedbranch,startdate: formattedStartDate, enddate: formattedEndDate,fm_id: widget.companyid,)));

                      selectedSupervisorName = selectedName;
                      id = selectedid;
                      code=selectedbranch;
                      //getSalesReportData(id,code);
                    }  );}),
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

              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                ],),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SingleChildScrollView(
                    child: CompanySalesData(
                      heading: heading,
                      data: dataa,
                      onTap: () {
                        Constants.customErrorSnack(context, "No Record Found");
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