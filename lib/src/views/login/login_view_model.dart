

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/configs/app_setup.locator.dart';
import 'package:premier/src/services/local/auth_service.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/services/remote/api_service.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:app_settings/app_settings.dart' as app;
import 'package:stacked/stacked.dart';

class LoginViewModel extends ReactiveViewModel
    with ApiViewModel, AuthViewModel {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isShowPassword = false;

  init() async {
    await getCurrentPosition();
    if (authService.user != null) {
      ApiService api = locator<ApiService>();
      AuthService authService = locator<AuthService>();
      getCurrentPosition().then((value) {
        if(value != null && authService.user != null){
          api.getAndSetLocationInBg(LatLng(value.latitude, value.longitude));
        }
      });
      Future.delayed(Duration.zero, () {
        NavService.dashboard();


        print("user${authService.user?.data?.loginType}");
      });
    }
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
  onLogin(BuildContext context) {
    if (m.Form.of(context)!.validate()) {
      setBusy(true);
      login(context, () {
        NavService.dashboard();
        Constants.customSuccessSnack(context, "Welcome ${authService.user?.data?.userName}");
      });
    }
  }

  Future<void> login(BuildContext context, Function callBack) async {
    var newsResponse = await runBusyFuture(apiService.login(context, username.value.text.trim(), password.value.text.trim()));
    newsResponse?.when(success: (data) async {
      authService.user = data;
      callBack();
      setBusy(false);
    }, failure: (error) {
      setBusy(false);
      Constants.customErrorSnack(context, error.toString());
    });
  }
}
