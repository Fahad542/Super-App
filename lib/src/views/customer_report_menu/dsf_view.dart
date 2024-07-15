import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/company_table_data.dart';
import '../../shared/DSF/supervisor_report.dart';
import '../../styles/app_colors.dart';

class dsf_view extends StatefulWidget {
  String? code;
  String? name;
  String? fm_id;
  String? zsm_id;
  dsf_view({Key? key, this.fm_id, this.code, this.name, zsm_id}) : super(key: key);
  @override
  State<dsf_view> createState() => _fmsalesState();
}
hand heading = hand(
    companyName: "ID/""DSF Name", invCount: "Total Cus", totalSales: "UC's"
);
List<hand> dataa = [];
DateFormat dateFormat = DateFormat('yyyy-MM-dd');
DateTime? startDates;
DateTime? endDates;
String formattedStartDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
String formattedEndDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
bool isLoading=false;
class _fmsalesState extends State<dsf_view> {
  Future<void> getSupervisorReportData(String a, String b) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().fmsalesreport(
        context as BuildContext, a, b, widget.zsm_id.toString());


    print(response);
    print('Response Data:$response');
    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(hand(
            companyName: '${element.fm_id.toString()}-${element.fm_name
                .toString()}',
            companyid: element.fm_id.toString(),
            invCount: element.totalInvoices.toString(),
            // start: element.start.toString(),,
            totalSales: element.totalSaleamount.toString()
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
    startDates = DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month, 1);
    endDates = DateTime.now();

    getSupervisorReportData(startDates.toString(), endDates.toString());
    // TODO: implement initState
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
        "DSF View",
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

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child:   Text(widget.name.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold
            ),),
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
                            supervisorreport(id: companyid.toString(),
                                name: name,
                                amount: amount,
                                startdate: startDates.toString(),
                                enddate: endDates.toString())));
                    print(formattedStartDate);
                    print(formattedEndDate);
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