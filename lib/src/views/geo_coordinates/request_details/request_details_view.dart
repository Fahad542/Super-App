import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/views/geo_coordinates/request_details/geo_tag.dart';
import 'package:premier/src/views/geo_coordinates/request_details/request_details_view_model.dart';
import 'package:stacked/stacked.dart';
import '../../../models/geo_coordinates/request_details_model.dart';
import '../../../styles/text_theme.dart';
import '../widgets/custom_buttom.dart';

class request_details_view extends StatelessWidget {
  final String? dsf_name;
  final String? dsf_code;
  final String? customer_code;
  final String? customer_name;
  final String? branch_code;
  final String? date;
  const request_details_view({Key? key, required this.dsf_name, required this.dsf_code, required this.customer_name, required this.customer_code, required this.branch_code, required this. date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String indexlist='';
    return ViewModelBuilder<request_details_view_model>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(
              "Request Details",
              style: TextStyle(color: AppColors.white),
            ),
            iconTheme: IconThemeData(color: AppColors.white),
            actions: [
              // Add any actions or buttons you need in the app bar
            ],
          ),
          body:
          model.isBusy
              ? Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          )
               :
        SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: "DSF:  ",
                        style: TextStyling.mediumRegular.copyWith(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: dsf_code.toString() + ' - ' + dsf_name.toString(),
                            style: TextStyling.mediumRegular.copyWith(
                              color: AppColors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  VerticalSpacing(10),

                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: "Customer:  ",
                        style: TextStyling.mediumRegular.copyWith(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: customer_code.toString() +
                                ' - ' +
                                customer_name.toString(),
                            style: TextStyling.mediumRegular.copyWith(
                              color: AppColors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:model.geo_data.length,
                      physics: BouncingScrollPhysics(),

                      itemBuilder: (context, index) {
                        Request_details_data data = model.geo_data[index];

                       // model.listindex=index.toString();
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.6),
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "Dsf Location: ",

                                      style: TextStyling.mediumRegular.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        fontSize: 15,
                                      ),
                                      children: [
                                        WidgetSpan(
                                          child: InkWell(
                                            onTap:(){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => geotag(lat: data.dsf_latitude,lon: data.dsf_longitude,
                                                    )

                                                ),
                                              );
                                              //GoogleMap(initialCameraPosition: ,);
                                            },
                                            child: Icon(
                                              Icons.location_on,
                                              color: AppColors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  RichText(
                                    text: TextSpan(
                                      text: "Original Location: ",
                                      style: TextStyling.mediumRegular.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,

                                      ),
                                      children: [
                                        WidgetSpan(
                                          child: InkWell(
                                            onTap:(){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => geotag(lat: data.original_latitude,lon: data.original_longitude,
                                                    )

                                                ),
                                              );
                                              //GoogleMap(initialCameraPosition: ,);
                                            },
                                            child: Icon(
                                              Icons.location_on,
                                              color: AppColors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  //  textDirection: TextDirection.ltr,
                                  ),

                                ],
                              ),

                              VerticalSpacing(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  latlong(title: 'See Coordinates',onTap: (){

                                    model.lat_long(context, data.dsf_latitude.toString(),data.dsf_longitude.toString());
                                  },),
                                  latlong(title: 'See Coordinates',onTap: (){ model.lat_long(context, data.original_latitude.toString(),data.original_longitude.toString());},)


                                ],),
                              VerticalSpacing(20),
                              Row(
                                children: [
                               Spacer(),
                                  custombuttom(
                                    title: 'Approved',
                                    onTap: () async {
                                      await model.showCustomDialog( context, "Approve", data.request_id.toString(), "Approved");
                                     // Close the dialog
                                    },
                                  ),

                                  HorizontalSpacing(10),
                                      custombuttom(title: 'Rejected', onTap: () async {
                                      await  model.showCustomDialog(context,"Reject",data.request_id.toString(),"Reject");
                                      model.removeRequest(index);

                                      }
                                      ),
                                    ],
                                  ),

                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => request_details_view_model(date,customer_code,dsf_code,branch_code,customer_name),
      onModelReady: (model) => model.init(context),
    );
  }}