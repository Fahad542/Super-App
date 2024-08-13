import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:premier/src/app/app_view.dart';
import 'package:premier/src/configs/app_setup.locator.dart';
import 'package:premier/src/services/local/auth_service.dart';
import 'package:premier/src/services/local/background_serv.dart';
import 'package:premier/src/services/local/flavor_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Push_notifications.dart';

void main() async {
  final updateManager = UpdateManager();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseApi().initNotification();
  // _requestLocationPermission(); // Add this line for location permission
  AuthService.prefs = await SharedPreferences.getInstance();
  BackgroundServ.init();

  // getting package
  final package = await PackageInfo.fromPlatform();

  setupLocator();

  // app flavor init
  FlavorService.init(package);

  runApp(AppView());

  // PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // String version = packageInfo.version;
  // print("App Version: $version");
  await updateManager.checkForUpdate();

  /////////////////////////////

Future<void> _requestLocationPermission() async {
  // Request foreground location permission
  var status = await Permission.location.request();

  // Check the status of the permission request
  if (status.isGranted) {
    // Permission granted, proceed with your location-related functionality
  } else if (status.isDenied) {
    // Permission denied
    // You may want to inform the user or provide a way to manually enable the permission
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied
    // You may want to open the app settings so the user can manually enable the permission
    openAppSettings();
  }
}
}
class UpdateManager {
  Future<void> checkForUpdate() async {
    print('Checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        print('Update available');
        update();
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }
}

