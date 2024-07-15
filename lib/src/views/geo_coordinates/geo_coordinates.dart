import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/models/geo_coordinates/geo_coordinates.dart';
import 'package:premier/src/views/geo_coordinates/request_details/request_details_view.dart';
import 'package:stacked/stacked.dart';
import '../../shared/DSF/dsf_app_screen.dart';
import '../../shared/spacing.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_theme.dart';
import 'geo_coordinates_view_model.dart';
class geo_coordinates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<Geo_coordinateds_view_model>.reactive(
      builder: (context, model, child) => SupervisorAppScreen(
        title: "Request Geo Coordinates",
        body: (model.isBusy)
            ? Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        )
            : RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration.zero, () {
              model.init(context);
            });
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
               // SearchField(label: "label", hint: "hint", controller: model.searchController, onSearch: model.search()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      // Update the searchQuery when the user types in the TextField
                      model.searchQuery = value;
                      // Trigger the search method
                      model.search();
                    },
                    decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Type here to search",
                      hintStyle: TextStyle(
                        color: AppColors.primary, // Change the hint text color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey, // Light border color when not focused
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: AppColors.primary, // Border color when focused
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.geo_data.length,

    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) {
      geo_coordinates_data data = model.geo_data[index];
      return  Container(
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                  BoxShadow(
                      color:
                      AppColors.primary.withOpacity(0.6),
                      offset: Offset(1, 1),
                      blurRadius: 2)
              ]),
          margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      data.day_name.toString(),
            style: TextStyling.mediumRegular.copyWith(
                    color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold
            )),
                    RichText(
                      text: TextSpan(
                        text: "Req Date: ",
                        style: TextStyling.mediumRegular.copyWith(
                            color: AppColors.darkGrey, fontSize: 14,),
                        children: [
                          TextSpan(
                              text: data.request_date.toString(),
                              style: TextStyling.mediumRegular.copyWith(
                                color: AppColors.primary, fontSize: 14,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),


                  ],
              ),
              VerticalSpacing(10),
              RichText(
                  text:
                  TextSpan(
                    text: "DSF: ",
                    style: TextStyling.mediumRegular.copyWith(
                        color: AppColors.darkGrey),
                    children: [
                      TextSpan(
                          text: data.dsf_code.toString() + " - " + data.dsf_name.toString(),
                          style: TextStyling.mediumRegular.copyWith(
                            color: AppColors.primary, fontSize: 14,)),

                    ],
                  ),

              ),
              Divider(color: AppColors.lightGrey,),
              VerticalSpacing(10),
              RichText(
                text:
                TextSpan(
                  text: "Address: ",
                  style: TextStyling.mediumRegular.copyWith(
                      color: AppColors.darkGrey, fontSize: 14),
                  children: [
                    TextSpan(
                        text: data.customer_address.toString(),
                        style: TextStyling.mediumRegular.copyWith(
                          color: AppColors.primary, fontSize: 14,)
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.lightGrey,),
              VerticalSpacing(10),
              RichText(
                  text: TextSpan(
                    text: "Customer: ",
                    style: TextStyling.mediumRegular.copyWith(
                        color: AppColors.darkGrey),
                    children: [
                      TextSpan(
                          text: data.customer_code.toString() + " - " + data.customer_name.toString(),
                          style: TextStyling.mediumRegular.copyWith(
                            color: AppColors.primary, fontSize: 14,)),
                    ],
                  ),
              ),
              Divider(color: AppColors.lightGrey,),
              VerticalSpacing(10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
               // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    RichText(
                      text: TextSpan(
                        text: "Branch: ",
                        style: TextStyling.mediumRegular.copyWith(
                            color: AppColors.darkGrey),
                        children: [
                          TextSpan(
                              text: data.branch_code.toString() + " - " + data.branch_name.toString(),
                              style: TextStyling.mediumRegular.copyWith(
                                color: AppColors.primary, fontSize: 14,)),
                        ],
                      ),
                    ),

                    InkWell(
onTap: (){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => request_details_view(
          dsf_name: data.dsf_name,
          dsf_code: data.dsf_code,
          customer_name: data.customer_name,
          customer_code: data.customer_code,
      branch_code: data.branch_code,
        date: data.request_date
      )

    ),
  );
},
                      child: Container(

                       padding: EdgeInsets.all(6),
                   decoration:BoxDecoration(
                       boxShadow: [
                         BoxShadow(
                           color: Colors.grey.withOpacity(0.5),
                           spreadRadius: 2,
                           blurRadius: 5,
                           offset: Offset(0, 3), // changes the shadow position
                         ),
                       ],
                       borderRadius: BorderRadius.circular(10),
                       color: AppColors.primary
                   ),
                        child: Text("Click to View", style: TextStyle(color: Colors.white, fontSize: 10),)),
                    )
                    ],
              ),
              VerticalSpacing(10),


            ],
          ),

      );
    } ),
                ),

              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => Geo_coordinateds_view_model(),
      onModelReady: (model) => model.init(context),
    );
  }
}
// class geo_coordinates extends StatefulWidget {
//   const geo_coordinates({Key? key}) : super(key: key);
//
//   @override
//   State<geo_coordinates> createState() => _geo_coordinatesState();
// }
//
// class _geo_coordinatesState extends State<geo_coordinates> {
//   @override
//   Widget build(BuildContext context) {
//     return
//       ViewModelBuilder<Geo_coordinateds_view_model>.reactive(
//           builder: (context, model, child) => SupervisorAppScreen(
//               title: "Supervisor Dashboard",
//               body:
//
//       Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: new Icon(Icons.arrow_back),
//             color: Colors.white),
//         backgroundColor: AppColors.primary,
//         title: Text(
//           "Geo Coordinates",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: Column(
//         children: [
//
// SearchField(label: "label", hint: "hint", controller: controller, onSearch: (){}),
//
//           Expanded(
//             child: ListView.builder(
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text("items[index]"), // Corrected this line
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     ), viewModelBuilder: () {  }));
//
//   }
// }
