class DsfcompanyModel {
  List<Dsfreport>? data;

  DsfcompanyModel({this.data});

  DsfcompanyModel.fromJson(Map<String, dynamic> json) {
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
  String company_id;
  String company_name;
  int totalInvoices;
  String totalSaleamount;
  //String supervisor_id;

  Dsfreport({
    required this.company_id,
    required this.company_name,
    required this.totalInvoices,
    required this.totalSaleamount
  });

  factory Dsfreport.fromJson(Map<String, dynamic> json) => Dsfreport(
    company_id: json["company_id"],
    company_name: json["company_name"],
    totalInvoices: json["total_invoices"],
    totalSaleamount: json["total_saleamount"],
  );

  Map<String, dynamic> toJson() => {
    "company_id": company_id,
    "company_name": company_name,
    "total_invoices": totalInvoices,
    "total_saleamount": totalSaleamount,
  };
}
