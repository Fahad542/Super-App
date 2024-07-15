
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../base/utils/Constants.dart';
import '../../../services/remote/api_service.dart';
import '../../../shared/DSF/company_table_data.dart';
import '../../../styles/app_colors.dart';

class total_customers extends StatefulWidget {
  String? code;
  String? name;
  String? dsf_id;
  String? year;
  String? month;
  String? monthcount;
  total_customers({Key? key, this.dsf_id, this.code, this.name, this.year, this.month, this.monthcount}) : super(key: key);
  @override
  State<total_customers> createState() => _fmsalesState();
}
dsf heading = dsf(
    companyName: " Code" ,companyid: 'Customer Name '
);
List<dsf> dataa = [];
String? index;
String _searchQuery = ''; // Store the search query
 List<dsf> _filteredData=[];
DateFormat dateFormat = DateFormat('yyyy-MM-dd');
String? a;
bool isLoading=false;
class _fmsalesState extends State<total_customers> {
  Future<void> getSupervisorReportData(String a, String b, String c) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().tc_details(
        context as BuildContext, a, b, c);


    print(response);
    print('Response Data:$response');
    response?.when(success: (_s) async {
      dataa.clear();
      _s.data?.forEach((element) {
        dataa.add(dsf(companyName: element.customer_name.toString(), companyid: element.customer_code.toString())
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
  void _filterData() {
    setState(() {
      _filteredData = dataa.where((dsf) {
        final companyName = dsf.companyName.toLowerCase();
        final companyid = dsf.companyid.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return companyName.contains(query) || companyid.contains(query);
      }).toList();
    });
  }

  @override
  void initState() {

    setState(() {
     dataa=_filteredData;
  print(widget.monthcount);
  DateTime currentDate = DateTime.now();
  index = currentDate.month.toString().padLeft(2, '0');
  index=widget.monthcount;

});

    getSupervisorReportData(index.toString(),widget.year.toString(),widget.dsf_id.toString());

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                      color: AppColors.primary
                  ),
                  child: Text(" Month: ${widget.month.toString()}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),)),
              Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                      color: AppColors.primary
                  ),
                  child: Text(" Year: ${widget.year.toString()}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),)),
            ],
          ),
        ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child:   Text(widget.name.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary), // Add border color here
                borderRadius: BorderRadius.circular(8), // Add border radius here
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none, // Remove default border
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filterData(); // Call filtering logic on text change
                  });
                },
              ),
            ),
          ),
          Expanded(

            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child:
              SingleChildScrollView(
                  child:
                      dsfdetails(
                        heading: heading,
                        data: _filteredData,
                        onTap: (int companyid, String name, String amount) {
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