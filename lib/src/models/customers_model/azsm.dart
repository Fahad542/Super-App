import 'gm_sale_report_model.dart';

class azsmsalemodel {
  List<gmreport>? data;

  azsmsalemodel({this.data});

  azsmsalemodel.fromJson(Map<String, dynamic> json) {
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
  String azsm_id;
  String azsm_code;
  String azsm_name;
  int total_invoices;
  String total_saleamount;
  List<brandwisedetail>? branchwisedetail;
  //String supervisor_id;

  gmreport({
    required this.azsm_id,
    required this.azsm_code,
    required this.azsm_name,
    required this.total_invoices,
    required this.total_saleamount,
    this.branchwisedetail
  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    azsm_id: json["azsm_id"],
    azsm_code: json["azsm_code"],
    azsm_name: json["azsm_name"],
    total_invoices: json["total_invoices"],
    total_saleamount: json["total_saleamount"],
    branchwisedetail: json["branchwisedetail"] != null
        ? List<brandwisedetail>.from(json["branchwisedetail"]
        .map((x) => brandwisedetail.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "azsm_id": azsm_id,
    "azsm_code": azsm_code,
    "azsm_name": azsm_name,
    "total_invoices": total_invoices,
    "total_saleamount":total_saleamount,
    "branchwisedetail": branchwisedetail != null
        ? List<dynamic>.from(branchwisedetail!.map((x) => x.toJson()))
        : null,
  };
}
