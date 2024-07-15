class ZmCompanySalesReportModel {
  List<Datum>? data;

  ZmCompanySalesReportModel({this.data});

  ZmCompanySalesReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Datum>[];
      json['data'].forEach((v) {
        data!.add(new Datum.fromJson(v));
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

class Datum {
  String title;
  String company_id;
  int totalInvoices;
  String totalSaleamount;
  int execution_percentage;
  int booking_invoices;
  //String supervisor_id;

  Datum({
    required this.title,
    required this.company_id,
    required this.totalInvoices,
    required this.totalSaleamount,
    required this.execution_percentage,
    required this.booking_invoices

  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      company_id: json['company_id'],
      title: json["title"],
      totalInvoices: json["total_invoices"],
      totalSaleamount: json["total_saleamount"],
      execution_percentage: json['execution_percentage'],
      booking_invoices: json['booking_invoices']
  );

  Map<String, dynamic> toJson() => {
    "company_id": company_id,
    "title": title,
    "total_invoices": totalInvoices,
    "total_saleamount": totalSaleamount,
    "booking_invoices":booking_invoices,
    "execution_percentage":execution_percentage
  };
}
