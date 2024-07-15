import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../styles/app_colors.dart';
import 'Datecontainers.dart';
import 'company_dsf_sale_details.dart';
import 'company_table_data.dart';

class companysale extends StatefulWidget {
   String? id;
  final String? startdate;
  final String? enddate;
  String? code;
   String? name;
   String? fm_id;
   companysale({Key? key, this.id, this.code, this.name, this.startdate, this.enddate, this.fm_id}) : super(key: key);

  @override
  State<companysale> createState() => _companysaleState();
}

class _companysaleState extends State<companysale> {
  bool isLoading = false;
  bool generate=false;
  List<Widget> widgets = [];
  bool show = false;
  CompanySalesTable heading = CompanySalesTable(
      companyName: "ID/Company Name", BookingInv: "Booking Inv",ExecuteInv:"Execute Inv", ExecuteAmount: "Execute Amount");
  String totalInv = "0";
  String totalAmount = "0";
  DateTime? startDates;
  DateTime? endDates;
  DateTime? selectedDateFormat;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String formattedStartDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
  String formattedEndDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
  DateTime? end;
  TextEditingController selectedDate = TextEditingController();
  List<CompanyTableData> dataa = [];
  List<SupervisorData> supervisordataa = [];
  String selectedSupervisorName='Select Supervisor';
  String id="";
  String code='';
  String supervisorcode='';
  String supervisorbrach='';

  Future<void> getSalesReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().companysalesreport(context, formattedStartDate, formattedEndDate, a,b );


    print(response);
    print('Response Data:$response');
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
        //dsfcode=element.dsfCode;
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
  Future<void> getSalesReportData1(String a, String b,String c, String d) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().companysalesreport(context, a,b,c,d );


    print(response);
    print('Response Data:$response');
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
  ///////////////////
  Future<void> Supervisorlist() async {
    setState(() {
      isLoading = true;
    });
    var responses = await ApiService().supervisorList(context,widget.fm_id.toString());
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
if(widget.id!=null){
  formattedStartDate=widget.startdate.toString();
  formattedEndDate=widget.enddate.toString();
}
    if(widget.id!=null) {
      getSalesReportData1(
        widget.startdate.toString(),
          widget.enddate.toString(),
          widget.id.toString(),
          widget.code.toString());
    }
    else{
      getSalesReportData(
          id,
          code);
    }
    Supervisorlist();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: new Icon(Icons.arrow_back),
          color: Colors.white),
      backgroundColor: AppColors.primary,
      title: Text(
        'Company Sales Report',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    ),
      body:
      isLoading == true
          ? Container(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      )
          :  Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
                    children: [
       widget.id==null && widget.name==null ?
         SupervisorDatadropdown(
             selectedSupervisor: selectedSupervisorName,
             data: supervisordataa,
             onTap: (selectedName, selectedid, selectedbranch) {
               setState(() {
                 //print(selectedSupervisorName);
                 selectedSupervisorName = selectedName;
                 id = selectedid;
                 code = selectedbranch;
                 getSalesReportData(id, code);
                 print("Dropdown1");
               });
             })

: SupervisorDatadropdown(
           selectedSupervisor: widget.name,
           data: supervisordataa,
           onTap: (selectedName, selectedid, selectedbranch) {
             setState(() {
               //print(selectedSupervisorName);
               widget.name = selectedName;
               widget.id = selectedid;
               widget.code = selectedbranch;
               getSalesReportData(widget.id.toString(), widget.code.toString());
               print("Dropdown2");
             });
           }),


                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                           widget.id==null && widget.code==null ?
                                DateContainer(
                                    title: "Start Date",
                                    selectedDate: startDates,

                                    range: formattedStartDate,
                                    onDateSelected: (range) {
                                      setState(() {
                                        startDates = range;
                                        formattedStartDate = dateFormat.format(
                                            startDates ?? range);});
                                      setState(() {
                                        if (formattedStartDate != null &&
                                            formattedEndDate != null &&
                                            formattedStartDate.compareTo(formattedEndDate) <= 0) {

                                            getSalesReportData(
                                                id,
                                                code);
                                            print("id is not null  id:$id, code:$code");

                                        } else {
                                          // Handle the case where formattedStartDate is greater than formattedEndDate
                                          Constants.customErrorSnack(context, "Start date should be less than or equal to End date");
                                        }
                                        print("startdate1");
                                        print("startdate: $startDates, enddate: $endDates");


                                      });
                                    }

                                )

                           : DateContainer(
                               title: "Start Date",
                               selectedDate: startDates,

                               range: formattedStartDate,
                               onDateSelected: (range) {
                                 setState(() {
                                   startDates = range;
                                   formattedStartDate = dateFormat.format(
                                       startDates ?? range);});
                                  setState(() {
                                    if (formattedStartDate != null &&
                                        formattedEndDate != null &&
                                        formattedStartDate.compareTo(formattedEndDate) <= 0) {
                                        getSalesReportData1(
                                          formattedStartDate,
                                            formattedEndDate,
                                            widget.id.toString(),
                                            widget.code.toString());
                                        print("id is null   id:$id, code:$code");
                                    } else {
                                      // Handle the case where formattedStartDate is greater than formattedEndDate
                                      Constants.customErrorSnack(context, "Start date should be less than or equal to End date");
                                    }
                                    show = true;
                                  });
                                  print("startdate2");
                                  print("startdate: $startDates, enddate: $endDates");
                                }
                            ),
                            widget.id==null && widget.code==null  ?
                                DateContainer(
                                    title: "End Date",
                                    selectedDate: endDates,
                                    range: formattedEndDate,
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


                                            getSalesReportData(
                                                id,
                                                code);

                                        } else {

                                          Constants.customErrorSnack(context, "Start date should be less than or equal to End date");
                                        }

                                        print("startdate: $formattedStartDate, enddate: $formattedEndDate");
                                        show = true;
                                      });
                                      print("enddate1");
                                      print("startdate: $startDates, enddate: $endDates");
                                    }


                                ) :
                            DateContainer(
                                title: "End Date",
                                selectedDate:endDates,
                                range: formattedEndDate,
                                onDateSelected: (range) {
                                  setState(() {
                                    endDates = range;
                                    formattedEndDate = dateFormat.format(
                                        endDates ?? DateTime.now());
                                  });

                                  setState(() {
                                    if (formattedStartDate != null &&
                                        formattedEndDate != null &&
                                        formattedStartDate.compareTo(formattedEndDate) <= 0) {

                                        getSalesReportData1(
                                          formattedStartDate,
                                            formattedEndDate,
                                            widget.id.toString(),
                                            widget.code.toString());


                                    } else {

                                      Constants.customErrorSnack(context, "Start date should be less than or equal to End date");
                                    }

                                    print("enddate2");
                                    print("startdate: $startDates, enddate: $endDates");
                                  });
                                }

                            ),

                              ],
                            ),
                            //Column(children: [],),



                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(!show)
                            Text("Current Month Sale", style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),

                        ],),

                      Expanded(
                        child: SingleChildScrollView(
                          //scrollDirection: Axis.horizontal, // If needed
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CompanySalesDataTable(
                              heading: heading,
                              data: dataa,
                              onTap: (String companyid, String name) {
                                if(widget.id==null && widget.code==null) {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          Companydsfsaledetails(
                                              companyname: name,
                                              startdate: formattedStartDate,
                                              enddate: formattedEndDate,
                                              companyid: companyid,
                                              supervisorcode: id,
                                              supervisorbranch: code),
                                  )

                                  );
                                 print("formattedStartDate :$formattedStartDate") ;
                                 print("formattedEndDate :$formattedEndDate");
                                 print("object");
                                }
                                else
                                {
                                   {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            Companydsfsaledetails(
                                                companyname: name,
                                                startdate: formattedStartDate,
                                                enddate:  formattedEndDate,
                                                companyid: companyid,
                                                supervisorcode: widget.id.toString(),
                                                supervisorbranch: widget.code.toString(),
                                            ),
                                    )

                                    );print("formattedStartDate :$formattedStartDate") ;
                                    print("formattedEndDate :$formattedEndDate");

                                    }
                                  }
                                },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
    );
  }
}
