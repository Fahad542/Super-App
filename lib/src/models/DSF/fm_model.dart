import '../customers_model/gm_sale_report_model.dart';

class fmReportModel {
  List<Datum>? data;

  fmReportModel({this.data});

  fmReportModel.fromJson(Map<String, dynamic> json) {
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

class Datum {  String fm_id;
  String fm_code;
  String fm_name;
  int totalInvoices;
  String totalSaleamount;
List<brandwisedetail>? branchwisedetail;

  Datum({
    required this.fm_id,
    required this.fm_code,
    required this.fm_name,
    required this.totalInvoices,
    required this.totalSaleamount,
     this.branchwisedetail
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    fm_id: json["fm_id"],
    fm_code: json["fm_code"],
    fm_name: json["fm_name"],
    totalInvoices: json["total_invoices"],
    totalSaleamount: json["total_saleamount"],
    branchwisedetail: json["branchwisedetail"] != null
        ? List<brandwisedetail>.from(json["branchwisedetail"]
        .map((x) => brandwisedetail.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "fm_id": fm_id,
    "fm_code": fm_code,
    "fm_name": fm_name,
    "total_invoices": totalInvoices,
    "total_saleamount": totalSaleamount,
    "branchwisedetail": branchwisedetail != null
        ? List<dynamic>.from(branchwisedetail!.map((x) => x.toJson()))
        : null,
  };
}
