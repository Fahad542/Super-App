class SalesManModel {
  List<SalesManModelData>? data;

  SalesManModel({this.data});

  SalesManModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SalesManModelData>[];
      json['data'].forEach((v) {
        data!.add(new SalesManModelData.fromJson(v));
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

class SalesManModelData {
  String? salesmanId;
  String? salesmanName;

  SalesManModelData({this.salesmanId, this.salesmanName});

  SalesManModelData.fromJson(Map<String, dynamic> json) {
    salesmanId = json['salesman_id'];
    salesmanName = json['salesman_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesman_id'] = this.salesmanId;
    data['salesman_name'] = this.salesmanName;
    return data;
  }
}
