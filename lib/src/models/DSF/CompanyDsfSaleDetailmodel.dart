class Companydsfsaledetailmodel {
  List<Datum>? data;

  Companydsfsaledetailmodel({this.data});

  Companydsfsaledetailmodel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Datum>[];
      json['data'].forEach((v) {
        data!.add(new Datum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datum {
  String dsfId;
  String dsfCode;
  String dsfName;
  int totalInvoices;
  String totalSaleamount;
  //String supervisor_id;

  Datum({
    required this.dsfId,
    required this.dsfCode,
    required this.dsfName,
    required this.totalInvoices,
    required this.totalSaleamount
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    dsfId: json["dsf_id"],
    dsfCode: json["dsf_code"],
    dsfName: json["dsf_name"],
    totalInvoices: json["total_invoices"],
    totalSaleamount: json["total_saleamount"],
  );

  Map<String, dynamic> toJson() => {
    "dsf_id": dsfId,
    "dsf_code": dsfCode,
    "dsf_name": dsfName,
    "total_invoices": totalInvoices,
    "total_saleamount": totalSaleamount,
  };
}
