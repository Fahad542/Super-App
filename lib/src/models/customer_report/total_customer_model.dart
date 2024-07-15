class total_customer_report  {
  List<total_customer_data>? data;

  total_customer_report({this.data});

  total_customer_report.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <total_customer_data>[];
      json['data'].forEach((v) {
        data!.add(new total_customer_data.fromJson(v));
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

class total_customer_data {
  String? customer_name;
  String? customer_code;
  total_customer_data({this.customer_name,});

  total_customer_data.fromJson(Map<String, dynamic> json) {
    customer_name = json['customer_name'];
    customer_code = json['customer_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customer_name;
    data['customer_code'] = this.customer_code;

    return data;
  }
}
