
class zm_dsf_report {
  List<Datum>? data;

  zm_dsf_report({this.data});

  zm_dsf_report.fromJson(Map<String, dynamic> json) {
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
  String dsf_id;
  String dsf_code;
  String dsf_name;
  int totalInvoices;
  String totalSaleamount;
  String dsf_brname;
  //String supervisor_id;

  Datum({
    required this.dsf_id,
    required this.dsf_code,
    required this.dsf_name,
    required this.totalInvoices,
    required this.totalSaleamount,
    required this.dsf_brname
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    dsf_id: json["dsf_id"],
    dsf_code: json["dsf_code"],
    dsf_name: json["dsf_name"],
    totalInvoices: json["total_invoices"],
    totalSaleamount: json["total_saleamount"],
      dsf_brname: json['dsf_brname']
  );

  Map<String, dynamic> toJson() => {
    "dsf_id": dsf_id,
    "dsf_code": dsf_code,
    "dsf_name": dsf_name,
    "total_invoices": totalInvoices,
    "total_saleamount": totalSaleamount,
    "dsf_brname":dsf_brname
  };
}
