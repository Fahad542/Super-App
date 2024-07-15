import 'package:flutter/material.dart';
import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../styles/app_colors.dart';
import 'company_table_data.dart';

class dsf_company_sales extends StatefulWidget {
  final String dsfcompanyName;
  final String companyname;
  final String startdate;
  final String enddate;
  final String dsfid;
  final String companyid;

  const dsf_company_sales({Key? key, required this.dsfcompanyName, required this.startdate, required this.enddate, required this.dsfid, required this.companyid, required this.companyname}) : super(key: key);

  @override
  State<dsf_company_sales> createState() => _dsf_company_wiseState();
}

class _dsf_company_wiseState extends State<dsf_company_sales> {
  bool isLoading = false;
  CompanySalesDetailsTableDatanohand heading = CompanySalesDetailsTableDatanohand(
      companyName: "ID/"
          "Customer Name", invCount: "Invoices", totalSales: "Amount");

  List<CompanySalesDetailsTableDatanohand> dataa = [];

  Future<void> getSalesReportData() async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().DsfCompanyCustomerDetail(context, widget.startdate, widget.enddate,widget.dsfid,widget.companyid);

print(response);


    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(CompanySalesDetailsTableDatanohand(
          companyName: '${element.customer_id.toString()}-${element.customer_name.toString()}',
          invCount: element.totalInvoices.toString(),
          totalSales: element.totalSaleamount.toString(),
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
    getSalesReportData();

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
      title:
      Text(
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
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color:AppColors.white,borderRadius: BorderRadius.circular(10)),
                    child:
                Text( widget.companyname,style: TextStyle( fontSize: 15, fontWeight: FontWeight.w600, ),))
              ],),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SingleChildScrollView(
                    child: CompanySaleDatanohand(

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
