import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/models/DSF/dahsboard_data.dart';
import 'package:premier/src/models/map_model/map_model_data.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/views/route/route_dashboard/route_dashboard_view_model.dart';
import 'package:premier/src/views/route/widgets/custom_marker.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:map_launcher/map_launcher.dart' as gm;
import 'package:app_settings/app_settings.dart' as app;
import 'package:widget_to_marker/widget_to_marker.dart';

class AllRouteMapViewModel extends ReactiveViewModel
    with AuthViewModel, ApiViewModel {
  final List<RoutesData> routesData;
  AllRouteMapViewModel(this.routesData);

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 17,
  );

  late GoogleMapController controller;
  bool isInit = false;
  LatLng? originLatLon;
  Directions? info;
  RoutesData? selectedData;
  LatLng? selectedLatLon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Polyline> polylines = <Polyline>{};

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  init(BuildContext context) async {
    if (!isInit) {
      setBusy(true);
    }
    await getCurrentPosition(context);
    final Uint8List markIconsRider = await getImages(Assets.imagesRider, 80);
    Marker? _origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'Origin'),
      icon: BitmapDescriptor.fromBytes(markIconsRider),
      position: originLatLon ?? LatLng(0, 0),
    );
    markers[MarkerId("origin")] = _origin;
    LatLng _prevLatLon = originLatLon ?? LatLng(0, 0);
    routesData.forEach((element) async {
      int index = routesData.indexWhere((e) => e == element);
      final Uint8List markIconsStore = await getImages(Assets.imagesStore, 80);
      Marker _destination = Marker(
          markerId: MarkerId(element.name.toString()),
          infoWindow: InfoWindow(title: element.name.toString()),
          icon: await TextOnImage(
            text: element.seq.toString(),
          ).toBitmapDescriptor(imageSize: Size(300, 300)),
          // icon: BitmapDescriptor.fromBytes(markIconsStore),
          position:
              LatLng(double.parse(element.lat), double.parse(element.lon)),
          onTap: () async {
            polylines.clear();
            selectedData = element;
            selectedLatLon =
                LatLng(double.parse(element.lat), double.parse(element.lon));
            final singlePolyline = await _getRoutePolyline(
              start: originLatLon!,
              finish: selectedLatLon!,
              color: AppColors.primary,
              id: element.name
                  .replaceAll(" ", "")
                  .replaceAll(".", "")
                  .toLowerCase(),
            );
            getDirections(context, originLatLon!, selectedLatLon!);
            polylines.add(singlePolyline);
          });
      markers[MarkerId(element.name.toString())] = _destination;

      LatLng secondPolylineStart = _prevLatLon;
      LatLng secondPolylineFinish =
          LatLng(double.parse(element.lat), double.parse(element.lon));

      final secondPolyline = await _getRoutePolyline(
        start: secondPolylineStart,
        finish: secondPolylineFinish,
        color: AppColors.primary,
        id: element.name.replaceAll(" ", "").replaceAll(".", "").toLowerCase(),
      );
      polylines.add(secondPolyline);
      _prevLatLon =
          LatLng(double.parse(element.lat), double.parse(element.lon));
      notifyListeners();
    });
    isInit = true;
    setBusy(false);
  }

  onMap() async {
    if (await gm.MapLauncher.isMapAvailable(gm.MapType.google) ?? false) {
      await gm.MapLauncher.showDirections(
        mapType: gm.MapType.google,
        destination: gm.Coords(
            selectedLatLon?.latitude ?? 0, selectedLatLon?.longitude ?? 0),
        destinationTitle: selectedData?.name ?? "",
      );
    }
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Constants.customErrorSnack(context,
          "Location services are disabled. Please enable the services");
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
    if (!hasPermission) {
      Navigator.pop(context);
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      try {
        originLatLon = LatLng(position.latitude, position.longitude);
        CameraPosition _newLocation = CameraPosition(
          target: originLatLon ?? LatLng(0, 0),
          zoom: 17,
          tilt: 50.0,
        );
        initialCameraPosition = _newLocation;
        controller.moveCamera(CameraUpdate.newCameraPosition(_newLocation));
        notifyListeners();
      } catch (e) {
        setBusy(false);
        print(e);
      }
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getDirections(
      BuildContext context, LatLng origin, LatLng destination) async {
    var response = await apiService.getDirections(context, origin, destination);
    response?.when(success: (_d) async {
      info = _d;
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }

  Future<Polyline> _getRoutePolyline(
      {required LatLng start,
      required LatLng finish,
      required Color color,
      required String id,
      int width = 5}) async {
    final polylinePoints = PolylinePoints();
    final List<LatLng> polylineCoordinates = [];

    final startPoint = PointLatLng(start.latitude, start.longitude);
    final finishPoint = PointLatLng(finish.latitude, finish.longitude);

    final result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAFkvJ5vPzUed6bCEBWo6UC11RnthpwVdo",
      startPoint,
      finishPoint,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    }
    final polyline = Polyline(
      polylineId: PolylineId(id),
      color: color,
      points: polylineCoordinates,
      width: width,
    );
    return polyline;
  }
}
