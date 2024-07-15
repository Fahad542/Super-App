import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:app_settings/app_settings.dart' as app;
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:premier/src/views/route/route_dashboard/route_dashboard_view_model.dart';
import 'package:stacked/stacked.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:map_launcher/map_launcher.dart' as gm;

class AllSupervisorMapViewModel extends ReactiveViewModel with AuthViewModel, ApiViewModel {
  List<RoutesData> routesData = [];
  final String? branchId;

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 17,
  );

  late GoogleMapController controller;
  bool isInit = false;
  LatLng? originLatLon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  AllSupervisorMapViewModel(this.branchId);

  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


  Future<void> getSalesManLocation(BuildContext context) async {
    setBusy(true);
    var response = await apiService.getSalesManLocation(context);
    response?.when(success: (_d) async {
      _d.data?.forEach((element) {
        routesData.add(RoutesData(element.userName.toString(), element.locationUpdateDate.toString(), element.lastLatitude.toString(), element.lastLongitude.toString(), "", "", "", ""));
      });
      setBusy(false);
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
      setBusy(false);
    });
  }
  init(BuildContext context) async {
    if(!isInit){
      setBusy(true);
    }
    await getCurrentPosition(context);
    await getSalesManLocation(context);
    routesData.forEach((element) async {
      final Uint8List markIconsStore = await getImages(Assets.imagesPerson, 80);
      Marker _destination = Marker(
        markerId: MarkerId(element.name.toString()),
        infoWindow: InfoWindow(title: "${element.name.toString()}", snippet: "Updated On ${element.address.toString()}"),
        icon: BitmapDescriptor.fromBytes(markIconsStore),
        position: LatLng(double.parse(element.lat), double.parse(element.lon)),
      );
      markers[MarkerId(element.name.toString())] = _destination;
      notifyListeners();
    });
    isInit = true;
    setBusy(false);
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Constants.customErrorSnack(context, "Location services are disabled. Please enable the services");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      app.AppSettings.openAppSettings();
      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
      app.AppSettings.openAppSettings();
      return false;
    }
    return true;
  }
  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission){
      Navigator.pop(context);
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {

      try{
        originLatLon = LatLng(position.latitude, position.longitude);
        CameraPosition _newLocation = CameraPosition(
          target: originLatLon ?? LatLng(0, 0),
          zoom: 17,
          tilt: 50.0,
        );
        initialCameraPosition = _newLocation;
        controller.moveCamera(CameraUpdate.newCameraPosition(_newLocation));
        notifyListeners();
      }catch (e){
        setBusy(false);
        print(e);
      }

    }).catchError((e) {
      debugPrint(e);
    });
  }
}
