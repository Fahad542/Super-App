class SupervisorReportModel {
  List<Datum>? data;

  SupervisorReportModel({this.data});

  SupervisorReportModel.fromJson(Map<String, dynamic> json) {
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
  String supervisor_id;
  String supervisor_code;
  String supervisor_name;
  int totalInvoices;
  String totalSaleamount;
  String supervisor_branchname;
  //String supervisor_id;

  Datum({
    required this.supervisor_id,
    required this.supervisor_code,
    required this.supervisor_name,
    required this.totalInvoices,
    required this.totalSaleamount,
    required this.supervisor_branchname
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    supervisor_id: json["supervisor_id"],
    supervisor_code: json["supervisor_code"],
    supervisor_name: json["supervisor_name"],
    totalInvoices: json["total_invoices"],
    totalSaleamount: json["total_saleamount"],
      supervisor_branchname:json['supervisor_branchname']
  );

  Map<String, dynamic> toJson() => {
    "supervisor_id": supervisor_id,
    "supervisor_code": supervisor_code,
    "supervisor_name": supervisor_name,
    "total_invoices": totalInvoices,
    "total_saleamount": totalSaleamount,
    'supervisor_branchname':supervisor_branchname
  };
}
