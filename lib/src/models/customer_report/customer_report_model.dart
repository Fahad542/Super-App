class ApiResponse {
  String? status;
  String? status_message;
  String? s_month;
  String? s_month_name;
  String? s_year;
  Companyreport? companyReport;

  ApiResponse({
    this.status,
    this.status_message,
    this.s_month,
    this.s_month_name,
    this.s_year,
    this.companyReport,
  });

  ApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    status_message = json['status_message'];
    s_month = json['s_month'];
    s_month_name = json['s_month_name'];
    s_year = json['s_year'];
    companyReport = json['response'] != null ? Companyreport.fromJson(json['response']) : null;
  }
}

class Companyreport {
  List<Datum>? data;

  Companyreport({this.data});

  Companyreport.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Datum>[];
      json['data'].forEach((v) {
        data!.add(new Datum.fromJson(v));
      });
    }
  }
}

class Datum {
  String? fm_id;
  String? fm_code;
  String? fm_name;
  int? total_customers;
  int? total_ucs;

  Datum({this.fm_id, this.fm_code, this.fm_name, this.total_customers, this.total_ucs});

  Datum.fromJson(Map<String, dynamic> json) {
    fm_id = json['fm_id'];
    fm_name = json['fm_name'];
    fm_code = json['fm_code'];
    total_customers = json['total_customers'];
    total_ucs = json['total_ucs'];
  }
}
