class VersionModel {
  List<Datum>? data;

  VersionModel({this.data});

  VersionModel.fromJson(Map<String, dynamic> json) {
    if (json['status'] == '200' && json['status_message'] == 'Data Fetch Successfully') {
      data = [Datum.fromJson(json)];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'VersionModel{data: $data}';
  }
}

class Datum {
  final String status;
  final String statusMessage;
  final String versionNo;

  Datum({
    required this.status,
    required this.statusMessage,
    required this.versionNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    status: json['status'],
    statusMessage: json['status_message'],
    versionNo: json['version_no'],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'status_message': statusMessage,
    'version_no': versionNo,
  };

  @override
  String toString() {
    return 'Datum{status: $status, statusMessage: $statusMessage, versionNo: $versionNo}';
  }
}
