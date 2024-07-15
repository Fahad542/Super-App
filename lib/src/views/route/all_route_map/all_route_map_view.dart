import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:premier/src/views/route/route_dashboard/route_dashboard_view_model.dart';
import 'package:stacked/stacked.dart';

import 'all_route_map_view_model.dart';

class AllRouteMapView extends StatelessWidget {
  final List<RoutesData> routesData;

  const AllRouteMapView({Key? key, required this.routesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AllRouteMapViewModel>.reactive(
      builder: (context, model, child) => DSFaAppScreen(
        title: "All Route Maps",
        body: (model.isBusy)
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: model.initialCameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      model.controller = controller;
                      if (!model.isInit) model.init(context);
                      model.notifyListeners();
                    },
                    markers: Set<Marker>.of(model.markers.values),
                    polylines: model.polylines,
                  ),
                  if (model.selectedData != null)
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Badge(
                        backgroundColor: AppColors.primary,
                        label: Text(model.selectedData?.seq.toString() ?? "0",style: TextStyling.smallBold.copyWith(color: AppColors.white),),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: "Distance: ",
                                        style: TextStyling.mediumRegular.copyWith(color: AppColors.secondary),
                                        children: [
                                          TextSpan(
                                            text: model.info?.totalDistance.toString(),
                                            style: TextStyling.mediumBold.copyWith(color: AppColors.primary),
                                          )
                                        ]
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: "Time: ",
                                        style: TextStyling.mediumRegular.copyWith(color: AppColors.secondary),
                                        children: [
                                          TextSpan(
                                            text: model.info?.totalDuration.toString(),
                                            style: TextStyling.mediumBold.copyWith(color: AppColors.primary),
                                          )
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Shop Name: ",
                                    style: TextStyling.mediumRegular.copyWith(color: AppColors.secondary),
                                    children: [
                                      TextSpan(
                                        text: model.selectedData?.name.toString(),
                                        style: TextStyling.mediumBold.copyWith(color: AppColors.primary),
                                      )
                                    ]
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Shop Address: ",
                                    style: TextStyling.mediumRegular.copyWith(color: AppColors.secondary),
                                    children: [
                                      TextSpan(
                                        text: model.selectedData?.address.toString(),
                                        style: TextStyling.mediumBold.copyWith(color: AppColors.primary),
                                      )
                                    ]
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: "Amount: ",
                                        style: TextStyling.mediumRegular.copyWith(color: AppColors.secondary),
                                        children: [
                                          TextSpan(
                                            text: model.selectedData?.amount.toString(),
                                            style: TextStyling.mediumBold.copyWith(color: AppColors.primary),
                                          )
                                        ]
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      model.onMap();
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        height: 30,
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Start Ride",
                                            style: TextStyling.mediumBold
                                                .copyWith(color: AppColors.white),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (model.selectedData != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                          onTap: () {
                            model.isInit = false;
                            model.init(context);
                            model.info = null;
                            model.selectedData = null;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.1),
                                  offset: Offset(0, 0),
                                  blurRadius: 10,
                                ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            height: 36,
                            width: 36,
                            child: Icon(
                              Icons.my_location,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          )),
                    ),
                ],
              ),
      ),
      viewModelBuilder: () => AllRouteMapViewModel(routesData),
      // onModelReady: (model) => model.init(context),
    );
  }
}
