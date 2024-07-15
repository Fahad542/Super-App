import 'gm_sale_report_model.dart';

class zsmsalemodel {
  List<gmreport>? data;

  zsmsalemodel({this.data});

  zsmsalemodel.fromJson(Map<String, dynamic> json) {
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
  String zsm_id;
  String zsm_code;
  String zsm_name;
  int total_invoices;
  String total_saleamount;
  List<brandwisedetail>? branchwisedetail;
  //String supervisor_id;

  gmreport({
    required this.zsm_id,
    required this.zsm_code,
    required this.zsm_name,
    required this.total_invoices,
    required this.total_saleamount,
     this.branchwisedetail
  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    zsm_id: json["zsm_id"],
    zsm_code: json["zsm_code"],
    zsm_name: json["zsm_name"],
    total_invoices: json["total_invoices"],
    total_saleamount: json["total_saleamount"],
    branchwisedetail: json["branchwisedetail"] != null
        ? List<brandwisedetail>.from(json["branchwisedetail"]
        .map((x) => brandwisedetail.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "zsm_id": zsm_id,
    "zsm_code": zsm_code,
    "zsm_name": zsm_name,
    "total_invoices": total_invoices,
    "total_saleamount":total_saleamount,
    "branchwisedetail": branchwisedetail != null
        ? List<dynamic>.from(branchwisedetail!.map((x) => x.toJson()))
        : null,
  };
}
