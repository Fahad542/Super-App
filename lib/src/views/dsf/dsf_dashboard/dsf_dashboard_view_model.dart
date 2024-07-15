
import 'package:flutter/material.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/models/DSF/dahsboard_data.dart';
import 'package:premier/src/models/DSF/get_all_dsf_model.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class StatisticData {
  final String title;
  final String value;

  StatisticData(this.title, this.value);
}

class DSFViewModel extends ReactiveViewModel with AuthViewModel, ApiViewModel {
  late Map<String, double> dataMap;

  List<AllDsfModelData> allDsf = [];
  int selectedDsf = -1;
  List<StatisticData> statisticData = [];
  DFSDashboardData dashboardData = DFSDashboardData();

  TextEditingController fromDate = TextEditingController();
  DateTime? fromDateFormat;
  TextEditingController toDate = TextEditingController();
  DateTime? toDateFormat;

  update(BuildContext context, String startdate, String enddate) async {
    if (authService.user?.data?.Issupervisor == "1") {
      if (selectedDsf != -1) {
        AllDsfModelData _data = allDsf[selectedDsf];
        getCancelCustomerData(context, startdate, enddate,
            id: _data.dsfId, type: _data.userType, code: _data.dsfCode);
        getExecutedCustomerData(context, startdate, enddate,
            id: _data.dsfId, type: _data.userType, code: _data.dsfCode);
        getPendingCustomerData(context, startdate, enddate,
            id: _data.dsfId, type: _data.userType, code: _data.dsfCode);
        setBusy(true);
        await getData(context, startdate, enddate,
            id: _data.dsfId, type: _data.userType, code: _data.dsfCode);
        setBusy(false);
        notifyListeners();
      }
    } else {
      getCancelCustomerData(
          context, fromDateFormat.toString(), toDateFormat.toString());
      getExecutedCustomerData(
          context, fromDateFormat.toString(), toDateFormat.toString());
      getPendingCustomerData(
          context, fromDateFormat.toString(), toDateFormat.toString());
      setBusy(true);
      await getData(
          context, fromDateFormat.toString(), toDateFormat.toString());
      setBusy(false);
    }
  }

  CompanyTableData heading = CompanyTableData(
      companyName: "Company Name",
      invCount: "Total Invoices",
      totalSales: "Total Sales");
  List<CompanyTableData> companyData = [];

  CompanyTableData executedHeading = CompanyTableData(
      companyName: "Customer Name", invCount: "Invoices", totalSales: "Amount");
  List<CompanyTableData> executedData = [];
  String executedInvTotal = "0";
  String executedAmountTotal = "0";
  CompanyTableData canceledHeading = CompanyTableData(
      companyName: "Customer Name", invCount: "Invoices", totalSales: "Amount");
  CompanyTableData pendingHeading = CompanyTableData(
      companyName: "Customer Name", invCount: "Invoices", totalSales: "Amount");
  List<CompanyTableData> canceledData = [];
  String canceledInvTotal = "0";
  String canceledAmountTotal = "0";
  List<CompanyTableData> pendingData = [];
  String pendingInvTotal = "0";
  String pendingAmountTotal = "0";

  init(BuildContext context) async {
    if (authService.user?.data?.Issupervisor == "1") {
      getAllDsf(context);
    } else {
      getCancelCustomerData(context, "", "");
      getExecutedCustomerData(context, "", "");
      getPendingCustomerData(context, "", "");
      setBusy(true);
      await getData(context, "", "");
      setBusy(false);
    }
  }

  Future<void> getAllDsf(BuildContext context) async {
    var newsResponse = await runBusyFuture(apiService.getAllDSF(context));
    newsResponse?.when(success: (data) async {
      allDsf.clear();
      data.data?.forEach((element) {
        allDsf.add(element);
      });
      for (int i = 0; i < 6; i++) {
        if (i == 0)
          statisticData.add(StatisticData("Executed Invoices", "0"));
        else if (i == 1)
          statisticData.add(StatisticData("Total Executed Sales", "Rs.0/-"));
        else if (i == 2)
          statisticData.add(StatisticData("Canceled Invoices", "0"));
        else if (i == 3)
          statisticData.add(StatisticData("Total Canceled Sales", "Rs.0/-"));
        else if (i == 4)
          statisticData.add(StatisticData("Pending Invoices", "0"));
        else if (i == 5)
          statisticData.add(StatisticData("Total Pending Sales", "Rs.0/-"));
      }
      dataMap = {
        "Executed Invoices": 0,
        "Canceled Invoices": 0,
        "Pending Invoices": 0,
      };
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }

  Future<void> getData(BuildContext context, String start, String end,
      {String? id, String? type, String? code}) async {
    var newsResponse = await runBusyFuture(apiService
        .getDSFDashboard(context, start, end, id: id, type: type, code: code));
    newsResponse?.when(success: (data) async {
      dashboardData = data;
      statisticData.clear();
      companyData.clear();
      for (int i = 0; i < 6; i++) {
        if (i == 0)
          statisticData.add(StatisticData(
              "Executed Invoices", data.data![0].executedInvoice.toString()));
        else if (i == 1)
          statisticData.add(StatisticData("Total Executed Sales",
              "Rs.${data.data![0].totalExecutedSales.toString()}/-"));
        else if (i == 2)
          statisticData.add(StatisticData(
              "Canceled Invoices", data.data![0].cancelInvoice.toString()));
        else if (i == 3)
          statisticData.add(StatisticData("Total Canceled Sales",
              "Rs.${data.data![0].totalCancelInvoice.toString()}/-"));
        else if (i == 4)
          statisticData.add(StatisticData(
              "Pending Invoices", data.data![0].pendingInvoice.toString()));
        else if (i == 5)
          statisticData.add(StatisticData("Total Pending Sales",
              "Rs.${data.data![0].totalpendingInvoice.toString()}/-"));
      }
      dataMap = {
        "Executed Invoices":
            double.parse(data.data![0].executedInvoice.toString()),
        "Canceled Invoices":
            double.parse(data.data![0].cancelInvoice.toString()),
        "Pending Invoices":
            double.parse(data.data![0].pendingInvoice.toString()),
      };
      data.companyData?.forEach((element) {
        companyData.add(CompanyTableData(
            companyName: element.companyName.toString(),
            invCount: element.companyInv.toString(),
            totalSales: element.companySale.toString()));
      });
      if (start == "" && end == "") {
        //fromDateFormat = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(data.fromDate?.replaceAll("/", "-").toString() ?? "");
        // if(fromDateFormat != null) {
        //
        // }
        fromDate.text = data.fromDate!;
        toDate.text = data.toDate!;
        //toDateFormat = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(data.toDate?.replaceAll("/", "-").toString() ?? "");
        // if(toDateFormat != null) {
        //
        // }
      }
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }

  Future<void> getCancelCustomerData(
      BuildContext context, String start, String end,
      {String? id, String? type, String? code}) async {
    var cancelResponse = await apiService.getDSFCustomers(
        context, "cancel", start, end,
        id: id, type: type, code: code);
    cancelResponse?.when(success: (data) async {
      canceledData.clear();
      data.customerData?.forEach((element) {
        canceledData.add(CompanyTableData(
            companyName: element.customerName.toString(),
            invCount: element.companyInv.toString(),
            totalSales: element.companySale.toString()));
      });
      canceledInvTotal = data.customerInvTotal.toString();
      canceledAmountTotal = data.customerAmountTotal.toString();
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }

  Future<void> getPendingCustomerData(
      BuildContext context, String start, String end,
      {String? id, String? type, String? code}) async {
    var executedResponse = await apiService.getDSFCustomers(
        context, "pending", start, end,
        id: id, type: type, code: code);
    executedResponse?.when(success: (data) async {
      pendingData.clear();
      data.customerData?.forEach((element) {
        pendingData.add(CompanyTableData(
            companyName: element.customerName.toString(),
            invCount: element.companyInv.toString(),
            totalSales: element.companySale.toString()));
      });
      pendingInvTotal = data.customerInvTotal.toString();
      pendingAmountTotal = data.customerAmountTotal.toString();
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }

  Future<void> getExecutedCustomerData(
      BuildContext context, String start, String end,
      {String? id, String? type, String? code}) async {
    var executedResponse = await apiService.getDSFCustomers(
        context, "executed", start, end,
        id: id, type: type, code: code);
    executedResponse?.when(success: (data) async {
      executedData.clear();
      data.customerData?.forEach((element) {
        executedData.add(CompanyTableData(
            companyName: element.customerName.toString(),
            invCount: element.companyInv.toString(),
            totalSales: element.companySale.toString()));
      });
      executedInvTotal = data.customerInvTotal.toString();
      executedAmountTotal = data.customerAmountTotal.toString();
      notifyListeners();
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }
}
