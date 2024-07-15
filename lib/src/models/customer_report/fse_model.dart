class fse {
  List<gmreport>? data;

  fse({this.data});

  fse.fromJson(Map<String, dynamic> json) {
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
  int total_customers;
  int total_ucs;
  //String supervisor_id;

  gmreport({
    required this.fse_id,
    required this.fse_code,
    required this.fse_name,
    required this.total_customers,
    required this.total_ucs
  });

  factory gmreport.fromJson(Map<String, dynamic> json) => gmreport(
    fse_id: json["fse_id"],
    fse_code: json["fse_code"],
    fse_name: json["fse_name"],
    total_customers: json["total_customers"],
    total_ucs: json["total_ucs"],
  );

  Map<String, dynamic> toJson() => {
    "fse_id": fse_id,
    "fse_code": fse_code,
    "fse_name": fse_name,
    "total_customers": total_customers,
    "total_ucs":total_ucs
  };
}
