class SmModel {
  List<smreport>? data;

  SmModel({this.data});

  SmModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <smreport>[];
      json['data'].forEach((v) {
        data!.add(new smreport.fromJson(v));
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

class smreport {
  String sm_id;
  String sm_code;
  String sm_name;
  int total_customers;
  int total_ucs;
  //String supervisor_id;

  smreport({
    required this.sm_id,
    required this.sm_code,
    required this.sm_name,
    required this.total_customers,
    required this.total_ucs
  });

  factory smreport.fromJson(Map<String, dynamic> json) => smreport(
    sm_id: json["sm_id"],
    sm_code: json["sm_code"],
    sm_name: json["sm_name"],
    total_customers: json["total_customers"],
    total_ucs: json["total_ucs"],
  );

  Map<String, dynamic> toJson() => {
    "sm_id": sm_id,
    "sm_code": sm_code,
    "sm_name": sm_name,
    "total_customers": total_customers,
    "total_ucs":total_ucs
  };
}
