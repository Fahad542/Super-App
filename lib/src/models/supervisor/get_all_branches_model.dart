class AllBranchesModel {
  List<AllBranchesModelData>? data;

  AllBranchesModel({this.data});

  AllBranchesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllBranchesModelData>[];
      json['data'].forEach((v) {
        data!.add(new AllBranchesModelData.fromJson(v));
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

class AllBranchesModelData {
  String? branchId;
  String? branchName;

  AllBranchesModelData({this.branchId, this.branchName});

  AllBranchesModelData.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    branchName = json['branch_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch_id'] = this.branchId;
    data['branch_name'] = this.branchName;
    return data;
  }
}