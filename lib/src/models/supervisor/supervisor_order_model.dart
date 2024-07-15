class SupervisorOrderModel {
  List<SupervisorOrderModelData>? data;

  SupervisorOrderModel({this.data});

  SupervisorOrderModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SupervisorOrderModelData>[];
      json['data'].forEach((v) {
        data!.add(new SupervisorOrderModelData.fromJson(v));
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

class SupervisorOrderModelData {
  String? orderId;
  String? customerName;
  int? orderAmount;
  String? address;
  String? orderDate;
  String? deliveryDate;
  String? specialNote;
  String? contact;
  dynamic supplyid;
  String? orderStatus;
  String? brickCode;
  String? brickName;
  String? deliveryDay;
  String? salesmanCode;
  String? salesmanName;
  String? salesmanMobile;
  int? remarks;
  String? remarksText;
  String? branch_id;
  String? customer_code;

  SupervisorOrderModelData(
      {this.orderId,
        this.customerName,
        this.orderAmount,
        this.address,
        this.orderDate,
        this.deliveryDate,
        this.specialNote,
        this.contact,
        this.supplyid,
        this.orderStatus,
        this.brickCode,
        this.brickName,
        this.deliveryDay,
        this.salesmanCode,
        this.salesmanName,
        this.salesmanMobile,
        this.remarks,
        this.remarksText, this.branch_id,
        this.customer_code

      });

  SupervisorOrderModelData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    customerName = json['customer_name'];
    orderAmount = json['order_amount'];
    address = json['address'];
    orderDate = json['order_date'];
    deliveryDate = json['delivery_date'];
    specialNote = json['special_note'];
    contact = json['contact'];
    supplyid = json['supplyid'];
    orderStatus = json['order_status'];
    brickCode = json['brick_code'];
    brickName = json['brick_name'];
    deliveryDay = json['delivery_day'];
    salesmanCode = json['salesman_code'];
    salesmanName = json['salesman_name'];
    salesmanMobile = json['salesman_mobile'];
    remarks = json['remarks'];
    remarksText = json['remarks_text'];
    branch_id=json['branch_id'];
    customer_code=json['customer_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['customer_name'] = this.customerName;
    data['order_amount'] = this.orderAmount;
    data['address'] = this.address;
    data['order_date'] = this.orderDate;
    data['delivery_date'] = this.deliveryDate;
    data['special_note'] = this.specialNote;
    data['contact'] = this.contact;
    data['supplyid'] = this.supplyid;
    data['order_status'] = this.orderStatus;
    data['brick_code'] = this.brickCode;
    data['brick_name'] = this.brickName;
    data['delivery_day'] = this.deliveryDay;
    data['salesman_code'] = this.salesmanCode;
    data['salesman_name'] = this.salesmanName;
    data['salesman_mobile'] = this.salesmanMobile;
    data['remarks'] = this.remarks;
    data['remarks_text'] = this.remarksText;
    data['customer_code']=this.customer_code;
    data['branch_id']=this.branch_id;
    return data;
  }
}
