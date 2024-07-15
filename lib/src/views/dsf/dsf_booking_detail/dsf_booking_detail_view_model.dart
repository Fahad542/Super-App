import 'package:intl/intl.dart';
import 'package:premier/src/base/utils/constants.dart';
import 'package:premier/src/models/DSF/get_all_dsf_model.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:stacked/stacked.dart';


class DSFBookingDetailViewModel extends ReactiveViewModel with ApiViewModel, AuthViewModel {
  final BuildContext context;
  final AllDsfModelData? _d;

  DSFBookingDetailViewModel(this.context, this._d);


  String totalInv = "0";
  String totalAmount = "0";
  DateTime? selectedDateFormat;
  TextEditingController selectedDate = TextEditingController();
  CompanyTableData heading = CompanyTableData(companyName: "Customer Name", invCount: "Invoices", totalSales: "Amount");
  List<CompanyTableData> data = [];

  init() async {
    selectedDateFormat = DateTime.now();
    selectedDate.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
    await getDSFOrders(context);
    notifyListeners();
  }


  Future<void> getDSFOrders(BuildContext context) async {
    setBusy(true);
    var response = await apiService.getDSFOrders(context, selectedDate.text.toString(), id: _d?.dsfId ?? null, type: _d?.userType ?? null, code: _d?.dsfCode ?? null,);
    response?.when(success: (_d) async {
      data.clear();
      _d.customerData?.forEach((element) {
        data.add(CompanyTableData(companyName: element.customerName.toString(), invCount: element.customerInv.toString(), totalSales: element.customerSale.toString()));
      });
      totalInv = _d.customerInvTotal?.replaceAll(".00", "").toString() ?? "";
      totalAmount = _d.customerAmountTotal?.replaceAll(".00", "").toString() ?? "";
      setBusy(false);
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
      setBusy(false);
    });
  }

}
