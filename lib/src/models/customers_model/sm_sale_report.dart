import 'gm_sale_report_model.dart';

class smsalemodel {
  List<gmreport>? data;

  smsalemodel({this.data});

  smsalemodel.fromJson(Map<String, dynamic> json) {
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
  String sm_id;
  String sm_code;
  String sm_name;
  int total_invoices;
  String total_saleamount;
  List<brandwisedetail>? branchwisedetail;
  //String supervisor_id;

  gmreport({
    required this.sm_id,
    required this.sm_code,
    required this.sm_name,
    required this.total_invoices,
    required this.total_saleamount,
    this.branchwisedetail
  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    sm_id: json["sm_id"],
    sm_code: json["sm_code"],
    sm_name: json["sm_name"],
    total_invoices: json["total_invoices"],
    total_saleamount: json["total_saleamount"],
    branchwisedetail: json["branchwisedetail"] != null
        ? List<brandwisedetail>.from(json["branchwisedetail"]
        .map((x) => brandwisedetail.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "sm_id": sm_id,
    "sm_code": sm_code,
    "sm_name": sm_name,
    "total_invoices": total_invoices,
    "total_saleamount":total_saleamount,
    "branchwisedetail": branchwisedetail != null
        ? List<dynamic>.from(branchwisedetail!.map((x) => x.toJson()))
        : null,
  };
}
