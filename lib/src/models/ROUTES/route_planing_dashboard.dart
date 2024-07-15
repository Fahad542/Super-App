class RoutePlanningDashboardModel {
  List<RoutePlanningDashboardModelData>? data;
  List<Orderdata>? orderData;

  RoutePlanningDashboardModel({this.data, this.orderData});

  RoutePlanningDashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RoutePlanningDashboardModelData>[];
      json['data'].forEach((v) {
        data!.add(new RoutePlanningDashboardModelData.fromJson(v));
      });
    }
    if (json['orderdata'] != null) {
      orderData = <Orderdata>[];
      json['orderdata'].forEach((v) {
        orderData!.add(new Orderdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.orderData != null) {
      data['orderdata'] = this.orderData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoutePlanningDashboardModelData {
  String? totalShop;
  String? totalDistance;
  String? totalOrderamount;

  RoutePlanningDashboardModelData({this.totalShop, this.totalDistance, this.totalOrderamount});

  RoutePlanningDashboardModelData.fromJson(Map<String, dynamic> json) {
    totalShop = json['total_shop'];
    totalDistance = json['total_distance'];
    totalOrderamount = json['total_orderamount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_shop'] = this.totalShop;
    data['total_distance'] = this.totalDistance;
    data['total_orderamount'] = this.totalOrderamount;
    return data;
  }
}

class Orderdata {
  String? shopName;
  String? shopAddress;
  String? latitude;
  String? longitude;
  String? orderAmount;
  String? sequence;
  String? number;

  Orderdata(
      {this.shopName,
        this.shopAddress,
        this.latitude,
        this.longitude,
        this.sequence,
        this.number,
        this.orderAmount});

  Orderdata.fromJson(Map<String, dynamic> json) {
    shopName = json['shop_name'];
    shopAddress = json['shop_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    orderAmount = json['order_amount'];
    sequence = json['sequence'];
    number = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_name'] = this.shopName;
    data['shop_address'] = this.shopAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['order_amount'] = this.orderAmount;
    data['sequence'] = this.sequence;
    data['mobile'] = this.number;
    return data;
  }
}