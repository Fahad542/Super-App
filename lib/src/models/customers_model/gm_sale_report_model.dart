class Gmsalemodel {
  List<gmreport>? data;

  Gmsalemodel({this.data});

  Gmsalemodel.fromJson(Map<String, dynamic> json) {
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
  String gm_id;
  String gm_code;
  String gm_name;
  int total_invoices;
  String total_saleamount;
  List<brandwisedetail>? branchwisedetail; // Changed 'data' to 'branchwisedetail'

  gmreport({
    required this.gm_id,
    required this.gm_code,
    required this.gm_name,
    required this.total_invoices,
    required this.total_saleamount,
    this.branchwisedetail,
  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    gm_id: json["gm_id"],
    gm_code: json["gm_code"],
    gm_name: json["gm_name"],
    total_invoices: json["total_invoices"],
    total_saleamount: json["total_saleamount"],
    branchwisedetail: json["branchwisedetail"] != null
        ? List<brandwisedetail>.from(json["branchwisedetail"]
        .map((x) => brandwisedetail.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "gm_id": gm_id,
    "gm_code": gm_code,
    "gm_name": gm_name,
    "total_invoices": total_invoices,
    "total_saleamount": total_saleamount,
    "branchwisedetail": branchwisedetail != null
        ? List<dynamic>.from(branchwisedetail!.map((x) => x.toJson()))
        : null,
  };
}

class brandwisedetail {
  String saleamount;
  String branch_code;
  String branch_name;

  brandwisedetail({
    required this.saleamount,
    required this.branch_code,
    required this.branch_name,

  });

  factory brandwisedetail.fromJson(Map<String, dynamic> json) => brandwisedetail(
    saleamount: json["saleamount"],
    branch_code: json["branch_code"],
    branch_name: json["branch_name"],

  );

  Map<String, dynamic> toJson() => {
    "saleamount": saleamount,
    "branch_code": branch_code,
    "branch_name": branch_name,

  };
}