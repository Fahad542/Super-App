class azsmresponse {
  List<gmreport>? data;

  azsmresponse({this.data});

  azsmresponse.fromJson(Map<String, dynamic> json) {
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
  int total_customers;
  int total_ucs;
  //String supervisor_id;

  gmreport({
    required this.azsm_id,
    required this.azsm_code,
    required this.azsm_name,
    required this.total_customers,
    required this.total_ucs
  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    azsm_id: json["azsm_id"],
    azsm_code: json["azsm_code"],
    azsm_name: json["azsm_name"],
    total_customers: json["total_customers"],
    total_ucs: json["total_ucs"],
  );

  Map<String, dynamic> toJson() => {
    "azsm_id": azsm_id,
    "azsm_code": azsm_code,
    "azsm_name": azsm_name,
    "total_customers": total_customers,
    "total_ucs":total_ucs
  };
}
