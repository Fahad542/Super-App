import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../styles/app_colors.dart';
import 'company_table_data.dart';
import 'dsf_company_wise.dart';

class dsf_company_wises extends StatefulWidget {
  final String dsfcompanyName;
  final String startdate;
  final String enddate;
  final String id;
  //final String invCount;
  const dsf_company_wises({Key? key, required this.dsfcompanyName, required this.startdate, required this.enddate, required this.id}) : super(key: key);

  @override
  State<dsf_company_wises> createState() => _dsf_company_wiseState();
}

class _dsf_company_wiseState extends State<dsf_company_wises> {
  bool isLoading = false;
  CompanyTableData heading = CompanyTableData(
      companyName: "ID/"
          "Company Name", invCount: "Invoices", totalSales: "Amount");
  //String formattedStartDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
  List<CompanyTableData> dataa = [];
  //String formattedEndDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
  Future<void> getSalesReportData(String a, String b, String c) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().DsfCompanyDetail(context, widget.startdate, widget.enddate, widget.id);

    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(CompanyTableData(
          companyName:
          '${element.company_id.toString()}-${element.company_name.toString()}',
          invCount: element.totalInvoices.toString(),
          totalSales: element.totalSaleamount.toString(),

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
  @override
  void initState() {

    getSalesReportData(widget.startdate, widget.enddate, widget.id);

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
        widget.dsfcompanyName,
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
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SingleChildScrollView(
                    child: CompanyDataTable(
                      heading: heading,
                      data: dataa,
                      onTap: (int value) {
                        CompanyDataTable(
                          heading: heading,
                          data: dataa,
                          onTap: (int value) {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => dsf_company_wises(dsfcompanyName: heading.dsfcompanyname.toString(),startdate: "",enddate: "",id:value.toString(),)));
                          },
                        );
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