class UserModel {
  Data? data;
  List<MenuData>? menuData;

  UserModel({this.data, this.menuData});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['menudata'] != null) {
      menuData = <MenuData>[];
      json['menudata'].forEach((v) {
        menuData!.add(new MenuData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.menuData != null) {
      data['menudata'] = this.menuData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? userId;
  String? userName;
  String? userCode;
  String? loginName;
  String? loginPass;
  bool? isAdmin;
  String? loginType;
  String? activeStatus;
  String? branchId;
  String? image;
  String? Issupervisor;

  Data(
      {this.userId,
      this.userName,
      this.userCode,
      this.loginName,
      this.loginPass,
      this.isAdmin,
      this.loginType,
      this.image,
      this.branchId,
      this.activeStatus,
        this.Issupervisor
      });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userCode = json['user_code'];
    loginName = json['login_name'];
    loginPass = json['login_pass'];
    isAdmin = (json['is_admin'] == "1") ? true : (json['is_admin'] == "0") ? false : json['is_admin'];
    loginType = json['login_type'];
    branchId = json['branch_id'];
    activeStatus = json['active_status'];
    Issupervisor = json['is_supervisor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_code'] = this.userCode;
    data['login_name'] = this.loginName;
    data['login_pass'] = this.loginPass;
    data['is_admin'] = this.isAdmin;
    data['login_type'] = this.loginType;
    data['branch_id'] = this.branchId;
    data['active_status'] = this.activeStatus;
    data['is_supervisor'] = this.Issupervisor;
    return data;
  }
}

class MenuData {
  String? key;
  String? name;
  String? icon;
  String? status;

  MenuData({this.name, this.key, this.icon, this.status});

  MenuData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    icon = json['icon'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['status'] = this.status;
    return data;
  }
}
