class SalesManLocationModel {
  List<SalesManLocationModelData>? data;

  SalesManLocationModel({this.data});

  SalesManLocationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SalesManLocationModelData>[];
      json['data'].forEach((v) {
        data!.add(new SalesManLocationModelData.fromJson(v));
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

class SalesManLocationModelData {
  String? userName;
  String? lastLatitude;
  String? lastLongitude;
  String? locationUpdateDate;

  SalesManLocationModelData(
      {this.userName,
        this.lastLatitude,
        this.lastLongitude,
        this.locationUpdateDate});

  SalesManLocationModelData.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    lastLatitude = json['last_latitude'];
    lastLongitude = json['last_longitude'];
    locationUpdateDate = json['location_update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['last_latitude'] = this.lastLatitude;
    data['last_longitude'] = this.lastLongitude;
    data['location_update_date'] = this.locationUpdateDate;
    return data;
  }
}
