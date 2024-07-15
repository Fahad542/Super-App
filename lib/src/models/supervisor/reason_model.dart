class ReasonModel {
  List<ReasonModelData>? data;

  ReasonModel({this.data});

  ReasonModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ReasonModelData>[];
      json['data'].forEach((v) {
        data!.add(new ReasonModelData.fromJson(v));
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

class ReasonModelData {
  String? id;
  String? reason;

  ReasonModelData({this.id, this.reason});

  ReasonModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reason'] = this.reason;
    return data;
  }
}