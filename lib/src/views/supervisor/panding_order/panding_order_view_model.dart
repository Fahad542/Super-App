import 'package:flutter/material.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/models/supervisor/reason_model.dart';
import 'package:premier/src/models/supervisor/salesman_model.dart';
import 'package:premier/src/models/supervisor/supervisor_order_model.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:premier/src/views/supervisor/supervisor_dashboard/supervisor_dashboard_view_model.dart';
import 'package:stacked/stacked.dart';
import 'dart:math' show cos, sqrt, asin;
class PendingOrderViewModel extends ReactiveViewModel
    with AuthViewModel, ApiViewModel {
  final NewCardData data;
  final String? branchId;
  bool loading = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setBusy(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  PendingOrderViewModel(this.data, this.branchId);
  List<SupervisorOrderModelData> ordersData = [];
  List<SupervisorOrderModelData> _allOrdersData = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController remarks = TextEditingController();
  DateTime toDateFormat = DateTime.now();

  List<SalesManModelData> salesman = [];
  List<ReasonModelData> reasons = [];
  ReasonModelData? selectedReasons;
  List<int> selectedIndex = [];

  search() {
    if (searchController.text != "") {
      ordersData.clear();
      _allOrdersData
          .where((element) =>
              (element.brickName
                      ?.toLowerCase()
                      .contains(searchController.text.toLowerCase()) ??
                  false) ||
              (element.orderId?.contains(searchController.text) ?? false))
          .toList()
          .forEach((element) {
        ordersData.add(element);
      });
      notifyListeners();
    } else {
      ordersData.clear();
      _allOrdersData.forEach((element) {
        ordersData.add(element);
      });
      notifyListeners();
    }
  }

  init(BuildContext context) async {
    setBusy(true);
    print("object");
    if (authService.user?.data?.Issupervisor == "1") {
      await getData(context, branchId: branchId);
      notifyListeners();
      if (data.status == "3") {
        await getSalesMan(context, branchId: branchId);
      }
      if (data.status == "1") {
        await getReasons(context, branchId: branchId);
      }
    } else {
      await getData(context, branchId: branchId);
      notifyListeners();
      if (data.status == "3") {
        await getSalesMan(context);
      }
      if (data.status == "1") {
        await getReasons(context);
      }
    }
    setBusy(false);
  }

  Future<void> getData(BuildContext context, {String? branchId}) async {
    var response = await apiService.getOrderData(
        context, data.status, fromDate.text, toDate.text,
        branchId: branchId);
    // print(
    //     "Sand Data:${data.status},${fromDate.text} ,${toDate.text},${branchId}");
    response?.when(success: (_d) async {
      if ((_d.data?.length ?? 0) > 0) {
        _allOrdersData.clear();
        ordersData.clear();
        _d.data?.forEach((element) {
          _allOrdersData.add(element);
          ordersData.add(element);
        });
        notifyListeners();
      }
    }, failure: (error) async {
      notifyListeners();
      Constants.customErrorSnack(context, error.toString());
    });
  }

  //For Pending Order View Apis
  Future<void> assignDeliveryDate(
      BuildContext context, String orderId, String deliveryDate) async {
    var response =
        await apiService.assignDeliveryDate(context, orderId, deliveryDate);
    response?.when(success: (_d) async {
      Constants.customSuccessSnack(context, "Delivery Date Assigned");
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }
  Widget _buildContent() {
    if (loading) {
      // Show loading indicator
      return CircularProgressIndicator();
    } else {
      // Show your regular UI
      return YourRegularUIWidget();
    }
  }

  Future<void> orderConfirmation(BuildContext context, String orderId) async {

    var response = await apiService.orderConfirmation(context, orderId);
    setBusy(true);
    response?.when(success: (_d) async {

      Constants.customSuccessSnack(context, "Order Confirmed Successfully");

      await getData(context, branchId: branchId);
      notifyListeners();
      setBusy(false);
    }, failure: (error) async {
      Constants.customErrorSnack(context, error.toString());
      notifyListeners();
      setBusy(false);
    });
  }

  Future<void> orderCancellation(BuildContext context, String orderId) async {
    var response = await apiService.orderCancellation(
        context, orderId, selectedReasons?.reason.toString() ?? "");
    response?.when(success: (_d) async {
      Constants.customSuccessSnack(context, "Order Cancelled Successfully");
      await getData(context, branchId: branchId);
      notifyListeners();
    }, failure: (error) async {
      notifyListeners();
      Constants.customErrorSnack(context, error.toString());
    });
  }

  Future<void> assignSalesMan(BuildContext context, String orderId,
      String saleManName, String saleManId) async {
    var response = await apiService.assignSalesMan(
        context, orderId, saleManName, saleManId);
    response?.when(success: (_d) async {
      Constants.customSuccessSnack(context, "Sales Man Assign Successfully");
      await getData(context, branchId: branchId);
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
      notifyListeners();
    });
  }

  Future<void> addRemarks(BuildContext context, String orderId) async {
    var response = await apiService.addRemark(context, orderId, remarks.text);
    response?.when(success: (_d) async {
      Constants.customSuccessSnack(context, "Remarks Added Successfully");
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }

  Future<void> getSalesMan(BuildContext context, {String? branchId}) async {
    var response = await apiService.getSalesMan(context, branchId);
    response?.when(success: (_d) async {
      if ((_d.data?.length ?? 0) > 0) {
        _d.data?.forEach((element) {
          selectedIndex.add(-1);
          salesman.add(element);
        });
        notifyListeners();
      }
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }

  Future<void> getReasons(BuildContext context, {String? branchId}) async {
    var response = await apiService.getReasons(context, branchId);
    response?.when(success: (_d) async {
      if ((_d.data?.length ?? 0) > 0) {
        _d.data?.forEach((element) {
          reasons.add(element);
        });
        notifyListeners();
      }
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }
}
class YourRegularUIWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Your regular UI implementation
    return Container(
      // Your regular UI content
    );
  }
}