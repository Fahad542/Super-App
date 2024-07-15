import 'package:flutter/material.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/models/supervisor/get_all_branches_model.dart';
import 'package:premier/src/models/supervisor/supervisor_dashboard_model.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'dart:math' show cos, sqrt, asin;

class NewCardData {
  final String name;
  final String status;
  final String value;
  final Color color;

  NewCardData(this.name, this.value, this.status, this.color);
}

class SupervisorDashboardViewModel extends ReactiveViewModel
    with AuthViewModel, ApiViewModel {
  SupervisorDashboardModelData? data;
  List<NewCardData> cardData = [];
  List<AllBranchesModelData> allBranches = [];
  int selectedBranch = -1;

  init(BuildContext context) async {
    if (authService.user?.data?.Issupervisor == "1") {
      getBranches(context);
    } else {
      await getData(context);
    }
  }

  Future<void> getBranches(BuildContext context) async {
    setBusy(true);
    var response = await apiService.getAllBranch(context);
    response?.when(success: (_d) async {
      if ((_d.data?.length ?? 0) > 0) {
        allBranches.clear();
        _d.data?.forEach((element) {
          allBranches.add(element);
        });
        cardData.clear();
        if (selectedBranch != -1) {
          getData(context,
              branchId: allBranches[selectedBranch].branchId.toString());
        } else {
          cardData.add(NewCardData("Pending Orders", "0", "1", Colors.orange));
          cardData.add(NewCardData("Transfer Waiting Order", "0", "2", Colors.deepOrange));
          cardData
              .add(NewCardData("Confirmed Orders", "0", "3", Colors.lightBlue));
          cardData.add(
              NewCardData("Dispatch Orders", "0", "4", AppColors.secondary));
          cardData
              .add(NewCardData("Delivered Orders", "0", "7", AppColors.green));
          cardData
              .add(NewCardData("Cancelled Orders", "0", "5", AppColors.red));
        }
        setBusy(false);
        notifyListeners();
      }
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
      setBusy(false);
    });
  }

  Future<void> getData(BuildContext context, {String? branchId}) async {
    setBusy(true);
    var response =
        await apiService.getSupervisorDashboardData(context, branchId);
    response?.when(success: (_d) async {
      if ((_d.data?.length ?? 0) > 0) {
        data = _d.data![0];
        cardData.clear();
        cardData.add(NewCardData(
            "Pending Orders",
            _d.data![0].pendingOrders.toString(),
            _d.data![0].pendingStatus.toString(),
            Colors.orange));
        cardData.add(NewCardData(
            "Transfer Waiting Order",
            _d.data![0].transferWaitingOrders.toString(),
            _d.data![0].transferWaitingStatus.toString(),
            Colors.deepOrange));
        cardData.add(NewCardData(
            "Confirmed Orders",
            _d.data![0].confirmOrders.toString(),
            _d.data![0].confirmStatus.toString(),
            Colors.lightBlue));
        cardData.add(NewCardData(
            "Dispatch Orders",
            _d.data![0].dispatchOrders.toString(),
            _d.data![0].dispatchStatus.toString(),
            AppColors.secondary));
        cardData.add(NewCardData(
            "Cancelled Orders",
            _d.data![0].cancelledOrders.toString(),
            _d.data![0].cancelledStatus.toString(),
            AppColors.red));
        cardData.add(NewCardData(
            "Delivered Orders",
            _d.data![0].deliveredOrders.toString(),
            _d.data![0].deliveredStatus.toString(),
            AppColors.green));
        setBusy(false);
        notifyListeners();
      }
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
      setBusy(false);
    });
  }
}
