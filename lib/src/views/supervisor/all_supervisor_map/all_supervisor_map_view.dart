import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'all_supervisor_map_view_model.dart';

class AllSupervisorMapView extends StatelessWidget {
  final String? branchId;

  const AllSupervisorMapView({Key? key, this.branchId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AllSupervisorMapViewModel>.reactive(
      builder: (context, model, child) => SupervisorAppScreen(
        title: "All SalesMan",
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
                  ),
                ],
              ),
      ),
      viewModelBuilder: () => AllSupervisorMapViewModel(branchId),
      // onModelReady: (model) => model.init(context),
    );
  }
}
