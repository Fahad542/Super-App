import 'gm_sale_report_model.dart';

class ssmsalemodel {
  List<gmreport>? data;

  ssmsalemodel({this.data});

  ssmsalemodel.fromJson(Map<String, dynamic> json) {
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
  String ssm_id;
  String ssm_code;
  String ssm_name;
  int total_invoices;
  String total_saleamount;
  List<brandwisedetail>? branchwisedetail;
  //String supervisor_id;

  gmreport({
    required this.ssm_id,
    required this.ssm_code,
    required this.ssm_name,
    required this.total_invoices,
    required this.total_saleamount,
    this.branchwisedetail
  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    ssm_id: json["ssm_id"],
    ssm_code: json["ssm_code"],
    ssm_name: json["ssm_name"],
    total_invoices: json["total_invoices"],
    total_saleamount: json["total_saleamount"],
    branchwisedetail: json["branchwisedetail"] != null
        ? List<brandwisedetail>.from(json["branchwisedetail"]
        .map((x) => brandwisedetail.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "ssm_id": ssm_id,
    "ssm_code": ssm_code,
    "ssm_name": ssm_name,
    "total_invoices": total_invoices,
    "total_saleamount":total_saleamount,
    "branchwisedetail": branchwisedetail != null
        ? List<dynamic>.from(branchwisedetail!.map((x) => x.toJson()))
        : null,
  };
}
