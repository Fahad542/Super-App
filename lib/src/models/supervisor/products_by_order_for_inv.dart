class ProductsByOrderForInv {
  List<ProductsByOrderForInvData>? data;

  ProductsByOrderForInv({this.data});

  ProductsByOrderForInv.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProductsByOrderForInvData>[];
      json['data'].forEach((v) {
        data!.add(new ProductsByOrderForInvData.fromJson(v));
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

class ProductsByOrderForInvData {
  String? productId;
  String? skuId;
  String? productName;
  String? productPrice;
  String? orderQty;
  String? productImage;
  String? tp;
  String? cmpDis;
  String? paDis;
  String? gst1;
  String? gst2;
  String? advTax;
  String? supplyid;
  String? branchId;

  ProductsByOrderForInvData(
      {this.productId,
        this.skuId,
        this.productName,
        this.productPrice,
        this.orderQty,
        this.productImage,
        this.tp,
        this.cmpDis,
        this.paDis,
        this.gst1,
        this.gst2,
        this.advTax,
        this.supplyid,
        this.branchId});

  ProductsByOrderForInvData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    skuId = json['sku_id'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    orderQty = json['order_qty'];
    productImage = json['product_image'];
    tp = json['tp'];
    cmpDis = json['cmp_dis'];
    paDis = json['pa_dis'];
    gst1 = json['gst1'];
    gst2 = json['gst2'];
    advTax = json['adv_tax'];
    supplyid = json['supplyid'];
    branchId = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['sku_id'] = this.skuId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['order_qty'] = this.orderQty;
    data['product_image'] = this.productImage;
    data['tp'] = this.tp;
    data['cmp_dis'] = this.cmpDis;
    data['pa_dis'] = this.paDis;
    data['gst1'] = this.gst1;
    data['gst2'] = this.gst2;
    data['adv_tax'] = this.advTax;
    data['supplyid'] = this.supplyid;
    data['branch_id'] = this.branchId;
    return data;
  }
}
