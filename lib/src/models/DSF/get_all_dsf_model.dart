class AllDsfModel {
  List<AllDsfModelData>? data;

  AllDsfModel({this.data});

  AllDsfModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllDsfModelData>[];
      json['data'].forEach((v) {
        data!.add(new AllDsfModelData.fromJson(v));
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

class AllDsfModelData {
  String? dsfId;
  String? dsfCode;
  String? userType;
  String? dsfName;

  AllDsfModelData({this.dsfId, this.dsfCode, this.dsfName, this.userType});

  AllDsfModelData.fromJson(Map<String, dynamic> json) {
    dsfId = json['dsf_id'];
    dsfCode = json['dsf_code'];
    dsfName = json['dsf_name'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dsf_id'] = this.dsfId;
    data['dsf_code'] = this.dsfCode;
    data['dsf_name'] = this.dsfName;
    data['user_type'] = this.userType;
    return data;
  }
}
