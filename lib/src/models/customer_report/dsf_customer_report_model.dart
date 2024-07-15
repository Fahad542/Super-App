class dsf_customer_report_model {
  List<dsf_report_data>? data;

  dsf_customer_report_model({this.data});

  dsf_customer_report_model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <dsf_report_data>[];
      json['data'].forEach((v) {
        data!.add(new dsf_report_data.fromJson(v));
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

class dsf_report_data {
  String? dsf_id;
  String? dsf_code;
  String? dsf_name;
  int? total_customers;
  int? total_ucs;
  dsf_report_data({this.dsf_id, this.dsf_code, this.dsf_name, this.total_customers, this.total_ucs});

  dsf_report_data.fromJson(Map<String, dynamic> json) {
    dsf_id = json['dsf_id'];
    dsf_code = json['dsf_code'];
    dsf_name = json['dsf_name'];
    total_customers = json['total_customers'];
    total_ucs = json['total_ucs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dsf_id'] = this.dsf_id;
    data['dsf_code'] = this.dsf_code;
    data['dsf_name'] = this.dsf_name;
    data['total_customers'] = this.total_customers;
    data['total_ucs'] = this.total_ucs;
    return data;
  }
}
