

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/services/remote/api_service.dart';
import 'package:stacked/stacked.dart';


import '../../../base/utils/Constants.dart';
import '../../../models/geo_coordinates/request_details_model.dart';
import '../../../services/local/base/auth_view_model.dart';
import '../../../services/remote/base/api_view_model.dart';
import '../geo_coordinates.dart';

class request_details_view_model extends ReactiveViewModel
    with AuthViewModel, ApiViewModel {
  // TextEditingController searchController = TextEditingController();
   List<Request_details_data> geo_data = [];
   String? date;
   String? customer_code;
   String? dsf_code;
   String? branch_code;
   String? customer_name;

  request_details_view_model(this.date,this.customer_code, this.dsf_code, this.branch_code, this.customer_name);

   init(BuildContext context) async {


    setBusy(true);
     await getdata(context);
    setBusy(false);
     notifyListeners();
   }


   Future<void> lat_long(BuildContext context, String lat, String log) async {
     return showDialog<void>(
       context: context,
       barrierDismissible: true,
       builder: (BuildContext context) {
         return AlertDialog(

           title: Center(
             child: Text(
               "Coordinates",
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
             ),
           ),
           content: ConstrainedBox(
             constraints: BoxConstraints(
               maxHeight: MediaQuery.of(context).size.height * 0.2,
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 SizedBox(height: 8), // Add some space above the content
                 Text(
                   "Latitude: $lat",
                   style: TextStyle(fontSize: 17),
                 ),
                 SizedBox(height: 8), // Add some space between latitude and longitude
                 Text(
                   "Longitude: $log",
                   style: TextStyle(fontSize: 17),
                 ),
               ],
             ),
           ),
           contentPadding: EdgeInsets.all(16),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(12),
             // You can add more decoration options like border and shadow here
           ),
           actions: <Widget>[
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: Text('OK', style: TextStyle(fontSize: 16)),
             ),
           ],
         );
       },
     );
   }
   Future<void> showCustomDialog(BuildContext context, String message,String id,String status) async {
     return showDialog<void>(
       context: context,
       builder: (cotext) {
         return AlertDialog(
           title: Text("$message Confirmation", style: TextStyle(fontWeight: FontWeight.bold),),
           content: Text("Do you want to $message the request"),
           actions: <Widget>[
             TextButton(
               onPressed: () async {
                 Navigator.of(context).pop();
                 ApiService api=ApiService();
                //setBusy(true);

                await api.request_details_status(context,
                         date.toString(),
                         customer_code.toString(),
                         dsf_code.toString(),
                         branch_code.toString(),
                         status,
                         customer_name.toString(),
                         id,);

                 if(status=="Approved"){
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => geo_coordinates(),
                     ),
                   );
                   Constants.customSuccessSnack(context, "Request is Approved");

                   // Close the dialog
                notifyListeners();
                 // Close the dialog when "OK" is pressed
               }

                 if(status=="Reject"){

                   Constants.customSuccessSnack(context, "Request is Reject");
                   //removeRequest(index);

                   notifyListeners();
                   // Close the dialog when "OK" is pressed
                 }



               },
               child: Text('OK'),
             ),
             TextButton(
               onPressed: () {Navigator.of(context).pop(); // Close the dialog when "Cancel" is pressed
               },
               child: Text('Cancel'),
             ),
           ],
         );
       },
     );
   }
   void removeRequest(int index) {
     if (index >= 0 && index < geo_data.length) {
       geo_data.removeAt(index);
       // Notify listeners to update the UI
       notifyListeners();
     }
   }

   getdata(BuildContext context) async {
   var newsResponse = await runBusyFuture(apiService.request_details(context,date.toString(),customer_code.toString(),dsf_code.toString(),branch_code.toString()));

     newsResponse?.when(success: (data) async {

      if ((data.data?.length ?? 0) > 0) {
        geo_data = data.data?.toList() ?? [];

      } else {
        Constants.customWarningSnack(context, "Data not found");
      }
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }




}





