import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/src/configs/app_setup.locator.dart';
import 'package:premier/src/services/local/auth_service.dart';
import 'package:premier/src/services/remote/api_service.dart';
import 'package:app_settings/app_settings.dart' as app;

class BackgroundServ{

  static Future<void> init() async {

    Timer.periodic(const Duration(minutes: 10), (timer) async {
      ApiService api = locator<ApiService>();
      AuthService authService = locator<AuthService>();
      getCurrentPosition().then((value) {
        if(value != null && authService.user != null){
          api.getAndSetLocationInBg(LatLng(value.latitude, value.longitude));
        }
      });
    });
  }


  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
  static Future<Position?> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission){
      return null;
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }



  // @pragma('vm:entry-point')
  // static Future<bool> onIosBackground(ServiceInstance service) async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   DartPluginRegistrant.ensureInitialized();
  //
  //
  //
  //   return true;
  // }
  //
  // @pragma('vm:entry-point')
  // static void onStart(ServiceInstance service) async {
  //   DartPluginRegistrant.ensureInitialized();
  //
  //
  //   /// OPTIONAL when use custom notification
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //   FlutterLocalNotificationsPlugin();
  //
  //   if (service is AndroidServiceInstance) {
  //     service.on('setAsForeground').listen((event) {
  //       service.setAsForegroundService();
  //     });
  //
  //     service.on('setAsBackground').listen((event) {
  //       service.setAsBackgroundService();
  //     });
  //   }
  //
  //   service.on('stopService').listen((event) {
  //     service.stopSelf();
  //   });
  //
  //   ApiService api = locator<ApiService>();
  //   // bring to foreground
  //   Timer.periodic(const Duration(seconds: 30), (timer) async {
  //     if (service is AndroidServiceInstance) {
  //       if (await service.isForegroundService()) {
  //         flutterLocalNotificationsPlugin.show(
  //           888,
  //           'COOL SERVICE',
  //           'Awesome ${DateTime.now()}',
  //           const NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               'my_foreground',
  //               'MY FOREGROUND SERVICE',
  //               '',
  //               icon: 'ic_bg_service_small',
  //               ongoing: true,
  //             ),
  //           ),
  //         );
  //         getCurrentPosition().then((value) {
  //           if(value != null){
  //             api.getAndSetLocationInBg(LatLng(value.latitude, value.longitude));
  //           }
  //         });
  //         // if you don't using custom notification, uncomment this
  //         service.setForegroundNotificationInfo(
  //           title: "live tracking on premier super app",
  //           content: "Updated at ${DateTime.now()}",
  //         );
  //       }
  //     }
  //
  //     /// you can see this log in logcat
  //     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  //
  //     // test using external plugin
  //     final deviceInfo = DeviceInfoPlugin();
  //     String? device;
  //     if (Platform.isAndroid) {
  //       final androidInfo = await deviceInfo.androidInfo;
  //       device = androidInfo.model;
  //     }
  //
  //     if (Platform.isIOS) {
  //       final iosInfo = await deviceInfo.iosInfo;
  //       device = iosInfo.model;
  //     }
  //
  //     service.invoke(
  //       'update',
  //       {
  //         "current_date": DateTime.now().toIso8601String(),
  //         "device": device,
  //       },
  //     );
  //   });
  // }

}
