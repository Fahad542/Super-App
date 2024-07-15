import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/models/DSF/dahsboard_data.dart';
import 'package:premier/src/models/ROUTES/all_salesman_model.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:url_launcher/url_launcher.dart';

class RoutesData {
  final String name;
  final String address;
  final String lat;
  final String lon;
  final String amount;
  final String distance;
  final String seq;
  final String mobile;

  RoutesData(this.name, this.address, this.lat, this.lon, this.amount,
      this.distance, this.seq, this.mobile);
}

class RouteViewModel extends ReactiveViewModel
    with AuthViewModel, ApiViewModel {
  String shops = "0";
  String amount = "0";

  List<RoutesData> data = [];
  List<AllSalesManModelData> allSalesMan = [];
  int selectedSalesman = -1;

  init(BuildContext context) async {
    if (authService.user?.data?.Issupervisor == "1") {
      await getAllSalesMan(context);
    } else {
      await getDSFOrders(context);
    }
  }

  launchWhatsapp(BuildContext context, String number) async {
    var whatsappAndroid = Uri.parse("whatsapp://send?phone=$number&text=salam");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  launchCall(BuildContext context, String number) async {
    var callAndroid = Uri.parse("tel://$number");
    if (await canLaunchUrl(callAndroid)) {
      await launchUrl(callAndroid);
    }
  }

  Future<void> getDSFOrders(BuildContext context, {String? code}) async {
    setBusy(true);
    var response =
        await apiService.getRoutePlanningDashboard(context, code: code);
    response?.when(success: (_d) async {
      data.clear();
      _d.orderData?.forEach((element) {
        String distance = (Geolocator.distanceBetween(
                    24.946218, 67.005615, 24.834396, 67.099497) /
                1000)
            .toStringAsFixed(2);
        data.add(RoutesData(
            element.shopName.toString(),
            element.shopAddress.toString(),
            element.latitude.toString(),
            element.longitude.toString(),
            element.orderAmount.toString(),
            distance,
            element.sequence.toString(),
            element.number.toString()));
      });
      amount = _d.data![0].totalOrderamount.toString();
      shops = _d.data![0].totalShop.toString();
      setBusy(false);
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
      setBusy(false);
    });
  }

  Future<void> getAllSalesMan(BuildContext context) async {
    setBusy(true);
    var response = await apiService.getAllSalesMan(context);
    response?.when(success: (_d) async {
      allSalesMan.clear();
      _d.data?.forEach((element) {
        allSalesMan.add(element);
      });
      setBusy(false);
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
      setBusy(false);
    });
  }
}
