import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/services/remote/api_service.dart';
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:premier/src/styles/app_colors.dart';
import '../../base/utils/Constants.dart';
class Companydsfsaledetails extends StatefulWidget {
  final String companyname;
  final String startdate;
  final String enddate;
  final String companyid;
  final String supervisorcode;
  final String supervisorbranch;

  const Companydsfsaledetails({Key? key, required this.companyname, required this.startdate, required this.enddate, required this.companyid, required this.supervisorcode, required this.supervisorbranch}) : super(key: key);
  @override
  State<Companydsfsaledetails> createState() => _SalesReportState();
}

class _SalesReportState extends State<Companydsfsaledetails> {
  bool isLoading = false;
  bool generate=false;
  List<Widget> widgets = [];
  bool show = false;
  CompanySalesDetailsTableDatanohand heading = CompanySalesDetailsTableDatanohand(
      companyName: "DSF ID/Name", invCount: "Invoices", totalSales: "Amount");
  String totalInv = "0";
  String totalAmount = "0";
  DateTime? startDates;
  DateTime? endDates;
  DateTime? selectedDateFormat;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String formattedStartDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
  String formattedEndDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
  TextEditingController selectedDate = TextEditingController();
  List<CompanySalesDetailsTableDatanohand> dataa = [];
  List<SupervisorData> supervisordataa = [];
  String selectedSupervisorName='Select Supervisor';
  String id="";
  String code='';

  Future<void> getSalesReportData() async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().CompanyDsfSaleDetail(context, widget.startdate, widget.enddate, widget.companyid, widget.supervisorcode, widget.supervisorbranch);

    print(response);
    print('Response Data:$response');
    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(CompanySalesDetailsTableDatanohand(

           brname: element.dsf_brname.toString(),
          companyName:'${element.dsfCode.toString()}-${element.dsfName.toString()}',
          invCount: element.totalInvoices.toString(),
          totalSales: element.totalSaleamount.toString(),
          dsfid: element.dsfId.toString(),

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
    var responses = await ApiService().supervisorList(context,"");
    print(responses);
    print('Response Data:$responses');
    responses?.when(success: (_d) async {
      supervisordataa.clear();

      _d.superdata?.forEach((element) {
        supervisordataa.add( SupervisorData(SupervisorName: element.supervisor_name, SupervisorId: element.supervisor_id, SupervisorCode: element.supervisor_code, branch: element.supervisor_branch)
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
    getSalesReportData();
    print(widget.startdate);
    print(widget.enddate);
    Supervisorlist();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Icon(Icons.arrow_back),
            color: Colors.white),
        backgroundColor: AppColors.primary,
        title: Text(
          widget.companyname,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body:

      isLoading == true
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [


            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [



                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color:AppColors.primary,borderRadius: BorderRadius.circular(10),

                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Start Date: ",
                          style: TextStyle(fontSize: 13, color: AppColors.white), // Set the weight to light
                        ),
                        TextSpan(text: widget.startdate,  style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.white)), // Date text
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color:AppColors.primary,borderRadius: BorderRadius.circular(10)),
                  child:
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "End Date: ",
                          style: TextStyle(fontSize: 13, color: AppColors.white), // Set the weight to light
                        ),
                        TextSpan(text: widget.enddate,  style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.white)), // Date text
                      ],
                    ),
                  ),
                )],),


            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CompanySaleDatanohand(
                    brcheck: true,
                    heading: heading,
                    data: dataa,
                    onTap: (int value) {
                      print("company: ${heading.dsfid}");
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => dsf_company_wise(dsfcompanyName: heading.dsfcompanyname.toString(),startdate: formattedStartDate,enddate: formattedEndDate,dsfid:value.toString(),)));
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

