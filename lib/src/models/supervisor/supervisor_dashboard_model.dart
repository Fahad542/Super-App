class SupervisorDashboardModel {
  List<SupervisorDashboardModelData>? data;

  SupervisorDashboardModel({this.data});

  SupervisorDashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SupervisorDashboardModelData>[];
      json['data'].forEach((v) {
        data!.add(new SupervisorDashboardModelData.fromJson(v));
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

class SupervisorDashboardModelData {
  String? totalOrders;
  String? pendingStatus;
  String? pendingOrders;
  String? transferWaitingStatus;
  String? transferWaitingOrders;
  String? confirmStatus;
  String? confirmOrders;
  String? dispatchStatus;
  String? dispatchOrders;
  String? deliveredStatus;
  String? deliveredOrders;
  String? cancelledStatus;
  String? cancelledOrders;

  SupervisorDashboardModelData(
      {this.totalOrders,
        this.pendingStatus,
        this.pendingOrders,
        this.transferWaitingStatus,
        this.transferWaitingOrders,
        this.confirmStatus,
        this.confirmOrders,
        this.dispatchStatus,
        this.dispatchOrders,
        this.deliveredStatus,
        this.deliveredOrders,
        this.cancelledStatus,
        this.cancelledOrders});

  SupervisorDashboardModelData.fromJson(Map<String, dynamic> json) {
    totalOrders = json['totalOrders'];
    pendingStatus = json['pendingStatus'];
    pendingOrders = json['pendingOrders'];
    transferWaitingStatus = json['transferWaitingStatus'];
    transferWaitingOrders = json['transferWaitingOrders'];
    confirmStatus = json['confirmStatus'];
    confirmOrders = json['confirmOrders'];
    dispatchStatus = json['dispatchStatus'];
    dispatchOrders = json['dispatchOrders'];
    deliveredStatus = json['deliveredStatus'];
    deliveredOrders = json['deliveredOrders'];
    cancelledStatus = json['cancelledStatus'];
    cancelledOrders = json['cancelledOrders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalOrders'] = this.totalOrders;
    data['pendingStatus'] = this.pendingStatus;
    data['pendingOrders'] = this.pendingOrders;
    data['transferWaitingStatus'] = this.transferWaitingStatus;
    data['transferWaitingOrders'] = this.transferWaitingOrders;
    data['confirmStatus'] = this.confirmStatus;
    data['confirmOrders'] = this.confirmOrders;
    data['dispatchStatus'] = this.dispatchStatus;
    data['dispatchOrders'] = this.dispatchOrders;
    data['deliveredStatus'] = this.deliveredStatus;
    data['deliveredOrders'] = this.deliveredOrders;
    data['cancelledStatus'] = this.cancelledStatus;
    data['cancelledOrders'] = this.cancelledOrders;
    return data;
  }
}