class DFSDashboardData {
  List<Data>? data;
  List<Companydata>? companyData;
  String? companyInvTotal;
  String? todayBooking;
  String? companyAmountTotal;
  String? fromDate;
  String? toDate;

  DFSDashboardData(
      {this.data,
      this.companyData,
      this.companyInvTotal,
      this.todayBooking,
      this.companyAmountTotal,
      this.fromDate,
      this.toDate});

  DFSDashboardData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    if (json['companydata'] != null) {
      companyData = <Companydata>[];
      json['companydata'].forEach((v) {
        companyData!.add(new Companydata.fromJson(v));
      });
    }
    companyInvTotal = json['companyinvtotal'];
    companyAmountTotal = json['companyamounttotal'];
    todayBooking = json['today_booking'];
    fromDate = json['start_date'];
    toDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.companyData != null) {
      data['companydata'] = this.companyData!.map((v) => v.toJson()).toList();
    }
    data['companyinvtotal'] = this.companyInvTotal;
    data['companyamounttotal'] = this.companyAmountTotal;
    data['start_date'] = this.fromDate;
    data['today_booking'] = this.todayBooking;
    data['end_date'] = this.toDate;
    return data;
  }
}

class Data {
  int? executedInvoice;
  String? totalExecutedSales;
  String? cancelInvoice;
  String? totalCancelInvoice;
  String? pendingInvoice;
  String? totalpendingInvoice;

  Data(
      {this.executedInvoice,
      this.totalExecutedSales,
      this.cancelInvoice,
      this.totalCancelInvoice,
      this.pendingInvoice,
      this.totalpendingInvoice});

  Data.fromJson(Map<String, dynamic> json) {
    executedInvoice = json['executed_invoice'];
    totalExecutedSales = json['total_executed_sales'];
    cancelInvoice = json['cancel_invoice'];
    totalCancelInvoice = json['total_cancel_invoice'];
    pendingInvoice = json['pending_invoice'];
    totalpendingInvoice = json['total_pending_invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['executed_invoice'] = this.executedInvoice;
    data['total_executed_sales'] = this.totalExecutedSales;
    data['cancel_invoice'] = this.cancelInvoice;
    data['total_cancel_invoice'] = this.totalCancelInvoice;
    data['pending_invoice'] = this.pendingInvoice;
    data['total_pending_invoice'] = this.totalpendingInvoice;
    return data;
  }
}

class Companydata {
  String? companyName;
  int? companyInv;
  String? companySale;

  Companydata({this.companyName, this.companyInv, this.companySale});

  Companydata.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'];
    companyInv = json['company_inv'];
    companySale = json['company_sale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_name'] = this.companyName;
    data['company_inv'] = this.companyInv;
    data['company_sale'] = this.companySale;
    return data;
  }
}
