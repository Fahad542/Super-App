class ProductsByOrder {
  String? orderId;
  String? orderStatus;
  List<ProductsByOrderData>? data;

  ProductsByOrder({this.orderId, this.orderStatus, this.data});

  ProductsByOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderStatus = json['order_status'];
    if (json['data'] != null) {
      data = <ProductsByOrderData>[];
      json['data'].forEach((v) {
        data!.add(new ProductsByOrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_status'] = this.orderStatus;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsByOrderData {
  String? productId;
  String? skuId;
  String? productName;
  String? productPrice;
  String? orderQty;
  dynamic totalPrice;
  String? productImage;
  String? proformaQty;
  String? proformaPrice;
  String? deliveredPrice;
  String? deliveredQty;
  String? availableQty;
  String? product_code;

  ProductsByOrderData(
      {this.productId,
        this.skuId,
        this.productName,
        this.productPrice,
        this.orderQty,
        this.totalPrice,
        this.productImage,
        this.proformaQty,
        this.proformaPrice,
        this.deliveredPrice,
        this.deliveredQty,
        this.availableQty,
      this.product_code
      });

  ProductsByOrderData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    skuId = json['sku_id'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    orderQty = json['order_qty'];
    totalPrice = json['totalPrice'];
    productImage = json['product_image'];
    proformaQty = json['ProformaQty'];
    proformaPrice = json['ProformaPrice'];
    deliveredPrice = json['delivered_Price'];
    deliveredQty = json['delivered_Qty'];
    availableQty = json['available_qty'];
    product_code=json['product_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['sku_id'] = this.skuId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['order_qty'] = this.orderQty;
    data['totalPrice'] = this.totalPrice;
    data['product_image'] = this.productImage;
    data['ProformaQty'] = this.proformaQty;
    data['ProformaPrice'] = this.proformaPrice;
    data['delivered_Price'] = this.deliveredPrice;
    data['delivered_Qty'] = this.deliveredQty;
    data['available_qty'] = this.availableQty;
    data['product_code'] = this.product_code;
    return data;
  }
}
