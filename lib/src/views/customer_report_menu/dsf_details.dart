import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import 'Customer_report/total_customer.dart';
import 'Customer_report/ucs.dart';


class dsf_details extends StatefulWidget {
  String? code;
  String? name;
  String? month;
  String? year;
  String? dsf_id;
  final String countmonth;
  dsf_details({Key? key, this.dsf_id, this.code, this.name, this.month, this.year, required this.countmonth}) : super(key: key);

  @override
  State<dsf_details> createState() => _fmsalesState();
}

class _fmsalesState extends State<dsf_details> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,

          ),
            backgroundColor: AppColors.primary, // Replace with your desired color
          title: Text(
            "DSF Details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: "Total Customers", ),
              Tab(text: "UCS"),
            ],
              indicatorColor: Colors.white,
            labelColor: Colors.white, // Set the text color of selected tab
            unselectedLabelColor: Colors.white60,
          ),
        ),
        body: TabBarView(
          children: [
            total_customers(
                name: widget.name,
            dsf_id:widget.dsf_id ,
            year:widget.year,
              month: widget.month,
              monthcount: widget.countmonth,

            ),
            Uc(name: widget.name,
              dsf_id:widget.dsf_id ,
              year:widget.year,
              month: widget.month,
              countmonth: widget.countmonth,
            )
          ],
        ),
      ),
    );
  }
}