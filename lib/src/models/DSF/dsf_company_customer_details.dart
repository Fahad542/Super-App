class DsfcompanycustomerModel {
  List<Dsfreport>? data;

  DsfcompanycustomerModel({this.data});

  DsfcompanycustomerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Dsfreport>[];
      json['data'].forEach((v) {
        data!.add(new Dsfreport.fromJson(v));
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

class Dsfreport {
  String customer_id;
  String customer_name;
  int totalInvoices;
  String totalSaleamount;


  Dsfreport({
    required this.customer_id,
    required this.customer_name,
    required this.totalInvoices,
    required this.totalSaleamount
  });

  factory Dsfreport.fromJson(Map<String, dynamic> json) => Dsfreport(
    customer_id: json["customer_id"],
    customer_name: json["customer_name"],
    totalInvoices: json["total_invoices"],
    totalSaleamount: json["total_saleamount"],
  );

  Map<String, dynamic> toJson() => {
    "customer_id": customer_id,
    "customer_name": customer_name,
    "total_invoices": totalInvoices,
    "total_saleamount": totalSaleamount,
  };
}
