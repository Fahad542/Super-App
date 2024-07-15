import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/models/DSF/dahsboard_data.dart';
import 'package:premier/src/models/map_model/map_model_data.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:app_settings/app_settings.dart' as app;
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:premier/src/views/route/route_dashboard/route_dashboard_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:map_launcher/map_launcher.dart' as gm;

class RouteMapViewModel extends ReactiveViewModel with AuthViewModel, ApiViewModel {
  final RoutesData routesData;
  RouteMapViewModel(this.routesData);

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 17,
  );

  late GoogleMapController controller;
  bool isInit = false;
  LatLng? originLatLon;
  LatLng? destinationLatLon;
  Marker? origin;
  Marker? destination;
  Directions? info;

  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


  init(BuildContext context) async {
    if(!isInit){
      setBusy(true);
    }
    await getCurrentPosition(context);
    destinationLatLon = LatLng(double.parse(routesData.lat), double.parse(routesData.lon));
    final Uint8List markIconsRider = await getImages(Assets.imagesRider, 80);
    origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'Origin'),
      icon: BitmapDescriptor.fromBytes(markIconsRider),
      position: originLatLon ?? LatLng(0, 0),
    );
    final Uint8List markIconsStore = await getImages(Assets.imagesStore, 80);
    destination = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'destination'),
      icon: BitmapDescriptor.fromBytes(markIconsStore),
      position: LatLng(double.parse(routesData.lat), double.parse(routesData.lon)),
    );
    await getDirections(context);
    isInit = true;
    // Future.delayed(Duration(seconds: 10), (){
    //   getCurrentPosition(context);
    // });
    setBusy(false);
  }

  onMap() async{
    if (await gm.MapLauncher.isMapAvailable(gm.MapType.google) ?? false) {
      await gm.MapLauncher.showDirections(
        mapType: gm.MapType.google,
        destination: gm.Coords(destination?.position.latitude??0, destination?.position.longitude??0),
        destinationTitle: routesData.name,
      );
    }
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

  Future<void> getDirections(BuildContext context) async {
    var response = await apiService.getDirections(context, origin?.position ?? LatLng(0, 0), destination?.position ?? LatLng(0, 0));
    response?.when(success: (_d) async {
      info = _d;
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }
}
