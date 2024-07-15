class CustomerModelData {
  List<Customerdata>? customerData;
  String? customerInvTotal;
  String? customerAmountTotal;
  String? fromDate;
  String? toDate;

  CustomerModelData({this.customerData,this.customerInvTotal, this.customerAmountTotal, this.fromDate, this.toDate});

  CustomerModelData.fromJson(Map<String, dynamic> json) {
    if (json['customerdata'] != null) {
      customerData = <Customerdata>[];
      json['customerdata'].forEach((v) {
        customerData!.add(new Customerdata.fromJson(v));
      });
    }
    customerInvTotal = json['customerinvtotal'];
    customerAmountTotal = json['customeramounttotal'];
    fromDate = json['start_date'];
    toDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customerData != null) {
      data['customerdata'] = this.customerData!.map((v) => v.toJson()).toList();
    }
    data['customerinvtotal'] = this.customerInvTotal;
    data['customeramounttotal'] = this.customerAmountTotal;
    data['start_date'] = this.fromDate;
    data['end_date'] = this.toDate;
    return data;
  }
}

class Customerdata {
  String? customerId;
  String? customerName;
  int? companyInv;
  int? customerInv;
  String? companySale;
  String? customerSale;

  Customerdata(
      {this.customerId, this.customerName, this.companyInv, this.companySale, this.customerInv, this.customerSale});

  Customerdata.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    companyInv = json['company_inv'];
    companySale = json['company_sale'];
    customerInv = json['customer_inv'];
    customerSale = json['customer_sale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['company_inv'] = this.companyInv;
    data['company_sale'] = this.companySale;
    data['customer_sale'] = this.customerSale;
    data['customer_sale'] = this.customerInv;
    return data;
  }
}