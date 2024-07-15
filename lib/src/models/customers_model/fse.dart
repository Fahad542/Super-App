import 'gm_sale_report_model.dart';

class fsesalemodel {
  List<gmreport>? data;

  fsesalemodel({this.data});

  fsesalemodel.fromJson(Map<String, dynamic> json) {
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
  String fse_id;
  String fse_code;
  String fse_name;
  int total_invoices;
  String total_saleamount;
  String fse_brname;
  List<brandwisedetail>? branchwisedetail;
  //String supervisor_id;

  gmreport({
    required this.fse_id,
    required this.fse_code,
    required this.fse_name,
    required this.total_invoices,
    required this.total_saleamount,
    required this.fse_brname,
    this.branchwisedetail
  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    fse_id: json["fse_id"],
    fse_code: json["fse_code"],
    fse_name: json["fse_name"],
    fse_brname: json['fse_brname'],
    total_invoices: json["total_invoices"],
    total_saleamount: json["total_saleamount"],
    branchwisedetail: json["branchwisedetail"] != null
        ? List<brandwisedetail>.from(json["branchwisedetail"]
        .map((x) => brandwisedetail.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "fse_id": fse_id,
    "fse_code": fse_code,
    "fse_name": fse_name,
    "fse_brname":fse_brname,
    "total_invoices": total_invoices,
    "total_saleamount":total_saleamount,
    "branchwisedetail": branchwisedetail != null
        ? List<dynamic>.from(branchwisedetail!.map((x) => x.toJson()))
        : null,
  };
}
