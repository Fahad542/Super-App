import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:premier/src/views/route/route_dashboard/route_dashboard_view_model.dart';
import 'package:stacked/stacked.dart';

import 'route_map_view_model.dart';

class RouteMapView extends StatelessWidget {
  final RoutesData routesData;

  const RouteMapView({Key? key, required this.routesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RouteMapViewModel>.reactive(
      builder: (context, model, child) => DSFaAppScreen(
        title: "Route Maps",
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
                    markers: {
                      if (model.origin != null) model.origin!,
                      if (model.destination != null) model.destination!
                    },
                    polylines: {
                      if (model.info != null)
                          Polyline(
                            polylineId: const PolylineId('overview_polyline'),
                            color: AppColors.secondary,
                            consumeTapEvents: true,
                            width: 5,
                            points: model.info?.polylinePoints
                                    ?.map((e) => LatLng(e.latitude, e.longitude))
                                    .toList() ??
                                [],
                          ),
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
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
                                    style: TextStyling.mediumRegular
                                        .copyWith(color: AppColors.secondary),
                                    children: [
                                      TextSpan(
                                        text: model.info?.totalDistance
                                            .toString(),
                                        style: TextStyling.mediumBold
                                            .copyWith(color: AppColors.primary),
                                      )
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Time: ",
                                    style: TextStyling.mediumRegular
                                        .copyWith(color: AppColors.secondary),
                                    children: [
                                      TextSpan(
                                        text: model.info?.totalDuration
                                            .toString(),
                                        style: TextStyling.mediumBold
                                            .copyWith(color: AppColors.primary),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Shop Name: ",
                                style: TextStyling.mediumRegular
                                    .copyWith(color: AppColors.secondary),
                                children: [
                                  TextSpan(
                                    text: routesData.name.toString(),
                                    style: TextStyling.mediumBold
                                        .copyWith(color: AppColors.primary),
                                  )
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Shop Address: ",
                                style: TextStyling.mediumRegular
                                    .copyWith(color: AppColors.secondary),
                                children: [
                                  TextSpan(
                                    text: routesData.address.toString(),
                                    style: TextStyling.mediumBold
                                        .copyWith(color: AppColors.primary),
                                  )
                                ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: "Amount: ",
                                    style: TextStyling.mediumRegular
                                        .copyWith(color: AppColors.secondary),
                                    children: [
                                      TextSpan(
                                        text: routesData.amount.toString(),
                                        style: TextStyling.mediumBold
                                            .copyWith(color: AppColors.primary),
                                      )
                                    ]),
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
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                        onTap: () {
                          model.getCurrentPosition(context);
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
      viewModelBuilder: () => RouteMapViewModel(routesData),
      // onModelReady: (model) => model.init(context),
    );
  }
}
