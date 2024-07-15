class RsmModel {
  List<rsmreport>? data;

  RsmModel({this.data});

  RsmModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <rsmreport>[];
      json['data'].forEach((v) {
        data!.add(new rsmreport.fromJson(v));
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

class rsmreport {
  String rsm_id;
  String rsm_code;
  String rsm_name;
  int total_customers;
  int total_ucs;
  //String supervisor_id;

  rsmreport({
    required this.rsm_id,
    required this.rsm_code,
    required this.rsm_name,
    required this.total_customers,
    required this.total_ucs
  });

  factory rsmreport.fromJson(Map<String, dynamic> json) => rsmreport(
    rsm_id: json["rsm_id"],
    rsm_code: json["rsm_code"],
    rsm_name: json["rsm_name"],
    total_customers: json["total_customers"],
    total_ucs: json["total_ucs"],
  );

  Map<String, dynamic> toJson() => {
    "rsm_id": rsm_id,
    "rsm_code": rsm_code,
    "rsm_name": rsm_name,
    "total_customers": total_customers,
    "total_ucs":total_ucs
  };
}
