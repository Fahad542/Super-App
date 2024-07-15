class supervisor_customer_report  {
  List<supervisor_customer_report_data>? data;

  supervisor_customer_report({this.data});

  supervisor_customer_report.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <supervisor_customer_report_data>[];
      json['data'].forEach((v) {
        data!.add(new supervisor_customer_report_data.fromJson(v));
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

class supervisor_customer_report_data {
  String? supervisor_id;
  String? supervisor_code;
  String? supervisor_name;
  int? total_customers;
  int? total_ucs;
  supervisor_customer_report_data({this.supervisor_id, this.supervisor_code, this.supervisor_name, this.total_customers, this.total_ucs});

  supervisor_customer_report_data.fromJson(Map<String, dynamic> json) {
    supervisor_id = json['supervisor_id'];
    supervisor_code = json['supervisor_code'];
    supervisor_name = json['supervisor_name'];
    total_customers = json['total_customers'];
    total_ucs = json['total_ucs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supervisor_id'] = this.supervisor_id;
    data['supervisor_code'] = this.supervisor_code;
    data['supervisor_name'] = this.supervisor_name;
    data['total_customers'] = this.total_customers;
    data['total_ucs'] = this.total_ucs;
    return data;
  }
}
