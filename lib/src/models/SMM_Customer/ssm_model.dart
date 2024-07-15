class SsmModel {
  List<ssmreport>? data;

  SsmModel({this.data});

  SsmModel.fromJson(Map<String, dynamic> json) {
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
  String ssm_id;
  String ssm_code;
  String ssm_name;
  int total_customers;
  int total_ucs;
  //String supervisor_id;

  ssmreport({
    required this.ssm_id,
    required this.ssm_code,
    required this.ssm_name,
    required this.total_customers,
    required this.total_ucs
  });

  factory ssmreport.fromJson(Map<String, dynamic> json) => ssmreport(
    ssm_id: json["ssm_id"],
    ssm_code: json["ssm_code"],
    ssm_name: json["ssm_name"],
    total_customers: json["total_customers"],
    total_ucs: json["total_ucs"],
  );

  Map<String, dynamic> toJson() => {
    "ssm_id": ssm_id,
    "ssm_code": ssm_code,
    "ssm_name": ssm_name,
    "total_customers": total_customers,
    "total_ucs":total_ucs
  };
}
