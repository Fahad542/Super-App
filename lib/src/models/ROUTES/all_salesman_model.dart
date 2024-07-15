class AllSalesManModel {
  List<AllSalesManModelData>? data;

  AllSalesManModel({this.data});

  AllSalesManModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllSalesManModelData>[];
      json['data'].forEach((v) {
        data!.add(new AllSalesManModelData.fromJson(v));
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

class AllSalesManModelData {
  String? salesmanCode;
  String? salesmanName;

  AllSalesManModelData({this.salesmanCode, this.salesmanName});

  AllSalesManModelData.fromJson(Map<String, dynamic> json) {
    salesmanCode = json['salesman_code'];
    salesmanName = json['salesman_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesman_code'] = this.salesmanCode;
    data['salesman_name'] = this.salesmanName;
    return data;
  }
}
