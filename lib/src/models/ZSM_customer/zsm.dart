class zsmModel {
  List<ssmreport>? data;

  zsmModel({this.data});

  zsmModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ssmreport>[];
      json['data'].forEach((v) {
        data!.add(new ssmreport.fromJson(v));
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

class ssmreport {
  String zsm_id;
  String zsm_code;
  String zsm_name;
  int total_customers;
  int total_ucs;
  //String supervisor_id;

  ssmreport({
    required this.zsm_id,
    required this.zsm_code,
    required this.zsm_name,
    required this.total_customers,
    required this.total_ucs
  });

  factory ssmreport.fromJson(Map<String, dynamic> json) => ssmreport(
    zsm_id: json["zsm_id"],
    zsm_code: json["zsm_code"],
    zsm_name: json["zsm_name"],
    total_customers: json["total_customers"],
    total_ucs: json["total_ucs"],
  );

  Map<String, dynamic> toJson() => {
    "zsm_id": zsm_id,
    "zsm_code": zsm_code,
    "zsm_name": zsm_name,
    "total_customers": total_customers,
    "total_ucs":total_ucs
  };
}
