class geo_coordinates_model {
  List<geo_coordinates_data>? data;

  geo_coordinates_model({this.data});

  geo_coordinates_model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <geo_coordinates_data>[];
      json['data'].forEach((v) {
        data!.add(new geo_coordinates_data.fromJson(v));
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

class geo_coordinates_data {
  String? branch_code;
  String? branch_name;
  String? dsf_code;
  String? dsf_name;
  String? customer_code;
  String? customer_name;
  String? day_name;
  String? request_date;
  String? customer_address;
  geo_coordinates_data({this.branch_code, this.branch_name, this.dsf_code, this.dsf_name, this.customer_code,
    this.customer_name,this.day_name,this.request_date, this.customer_address

  });

  geo_coordinates_data.fromJson(Map<String, dynamic> json) {
    branch_code = json['branch_code'];
    branch_name = json['branch_name'];
    dsf_code = json['dsf_code'];
    dsf_name = json['dsf_name'];
    customer_code = json['customer_code'];
    customer_name = json['customer_name'];
    day_name = json['day_name'];
    request_date = json['request_date'];
    customer_address=json['customer_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch_code'] = this.branch_code;
    data['branch_name'] = this.branch_name;
    data['dsf_code'] = this.dsf_code;
    data['dsf_name'] = this.dsf_name;
    data['customer_code'] = this.customer_code;
    data['day_name'] = this.day_name;
    data['request_date'] = this.request_date;
    data['customer_address'] = this.customer_address;
    return data;
  }
}