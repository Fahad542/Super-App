class GmModel {
  List<gmreport>? data;

  GmModel({this.data});

  GmModel.fromJson(Map<String, dynamic> json) {
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
  int total_customers;
  int total_ucs;
  //String supervisor_id;

  gmreport({
    required this.gm_id,
    required this.gm_code,
    required this.gm_name,
    required this.total_customers,
    required this.total_ucs
  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    gm_id: json["gm_id"],
    gm_code: json["gm_code"],
    gm_name: json["gm_name"],
    total_customers: json["total_customers"],
    total_ucs: json["total_ucs"],
  );

  Map<String, dynamic> toJson() => {
    "gm_id": gm_id,
    "gm_code": gm_code,
    "gm_name": gm_name,
    "total_customers": total_customers,
    "total_ucs":total_ucs
  };
}
