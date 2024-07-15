class total_uc_report  {
List<total_uc_data>? data;

total_uc_report({this.data});

total_uc_report.fromJson(Map<String, dynamic> json) {
if (json['data'] != null) {
data = <total_uc_data>[];
json['data'].forEach((v) {
data!.add(new total_uc_data.fromJson(v));
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

class total_uc_data {
  String? customer_name;
  String? customer_code;
  total_uc_data({this.customer_name,this.customer_code});

  total_uc_data.fromJson(Map<String, dynamic> json) {
    customer_name = json['customer_name'];
customer_code=json['customer_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customer_name;
    data['customer_code'] = this.customer_code;
    return data;
  }
}
