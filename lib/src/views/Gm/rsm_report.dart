import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/views/Gm/sm.dart';
import 'package:premier/src/views/Gm/zsm.dart';
import '../../base/utils/Constants.dart';
import '../../services/remote/api_service.dart';
import '../../shared/DSF/company_table_data.dart';
import '../../styles/app_colors.dart';

// class rsm extends StatefulWidget {
//
//   final String month;
//   final String year;
//   final String id;
//   final String name;
//
//   const rsm({Key? key, required this.month, required this.year, required this.id, required this.name}) : super(key: key);
//
//   @override
//   State<rsm> createState() => _dsf_company_wiseState();
// }
//
// class _dsf_company_wiseState extends State<rsm> {
//   bool isLoading = false;
//   hand heading = hand(
//       companyName: "ID/"
//           "RSM Name", invCount: "Total Customer", totalSales: "UC's"
//
//   );
//   //String formattedStartDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01';
//   List<hand> dataa = [];
//   //String formattedEndDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
//   Future<void> getSalesReportData(String a, String b) async {
//     setState(() {
//       isLoading = true;
//     });
//     var response = await ApiService().rsm(context, a, b,widget.id);
//
//     response?.when(success: (_s) async {
//       dataa.clear();
//       _s.data?.forEach((element) {
//         dataa.add(hand(
//           companyName:
//           '${element.rsm_id.toString()}-${element.rsm_name.toString()}',
//           invCount: element.total_ucs.toString(),
//           dsfid: element.rsm_id.toString(),
//           companyid: element.rsm_id.toString(),
//           totalSales: element.total_customers.toString(),
//
//         )
//         );
//
//       });
//       setState(() {
//         isLoading = false;
//       });
//     }, failure: (error) {
//       Constants.customErrorSnack(context, error.toString());
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//   @override
//   void initState() {
//
//     getSalesReportData(widget.month,widget.year);
//
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(  appBar: AppBar(
//       leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: new Icon(Icons.arrow_back),
//           color: Colors.white),
//       backgroundColor: AppColors.primary,
//       title: Text(
//         widget.name ?? "SSM customer report show",
//         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//       ),
//     ),
//         body:   isLoading == true
//             ?
//
//
//         Container(
//           child: Center(
//             child: CircularProgressIndicator(
//               color: AppColors.primary,
//             ),
//           ),
//         )
//             :
//         Padding(
//           padding: const EdgeInsets.all(10),
//
//           child: Column(
//             children: [
//
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: SingleChildScrollView(
//                     child:
//                     handdetails(
//                       heading: heading,
//                       data: dataa,
//                       onTap: (int value, String name,String code) {
//                         print("company: ${heading.dsfid}");
//                         print(value);
//                         print(name);
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => zsm( month: widget.month, year: widget.year
//                           , id: value.toString(), name: name.toString(),)));
//                       },
//
//
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
//
//     );
//   }
// }