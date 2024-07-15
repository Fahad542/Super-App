import 'gm_sale_report_model.dart';

class rsmsalemodel {
  List<gmreport>? data;

  rsmsalemodel({this.data});

  rsmsalemodel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <gmreport>[];
      json['data'].forEach((v) {
        data!.add(new gmreport.fromJson(v));
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

class gmreport {
  String rsm_id;
  String rsm_code;
  String rsm_name;
  int total_invoices;
  String total_saleamount;
  List<brandwisedetail>? branchwisedetail;
  //String supervisor_id;

  gmreport({
    required this.rsm_id,
    required this.rsm_code,
    required this.rsm_name,
    required this.total_invoices,
    required this.total_saleamount,
    this.branchwisedetail

  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    rsm_id: json["rsm_id"],
    rsm_code: json["rsm_code"],
    rsm_name: json["rsm_name"],
    total_invoices: json["total_invoices"],
    total_saleamount: json["total_saleamount"],
    branchwisedetail: json["branchwisedetail"] != null
        ? List<brandwisedetail>.from(json["branchwisedetail"]
        .map((x) => brandwisedetail.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "rsm_id": rsm_id,
    "rsm_code": rsm_code,
    "rsm_name": rsm_name,
    "total_invoices": total_invoices,
    "total_saleamount":total_saleamount,
    "branchwisedetail": branchwisedetail != null
        ? List<dynamic>.from(branchwisedetail!.map((x) => x.toJson()))
        : null,
  };
}
