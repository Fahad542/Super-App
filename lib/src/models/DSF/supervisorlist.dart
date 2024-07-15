class SupervisorlistModel {
  List<Supervisor>? superdata;

  SupervisorlistModel({this.superdata});

  SupervisorlistModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      superdata = <Supervisor>[];
      json['data'].forEach((v) {
        superdata!.add(new Supervisor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> superdata = new Map<String, dynamic>();
    if (this.superdata != null) {
      superdata['data'] = this.superdata!.map((v) => v.toJson()).toList();
    }
    return superdata;
  }
}
class Supervisor {
  String supervisor_id;
  String supervisor_name;
  String supervisor_code;
  String supervisor_branch;


  Supervisor({
    required this.supervisor_id,
    required this.supervisor_name,
    required this.supervisor_code,
    required this.supervisor_branch

  });

  factory Supervisor.fromJson(Map<String, dynamic> json) => Supervisor(
    supervisor_id: json["supervisor_id"],
    supervisor_name: json["supervisor_name"],
      supervisor_code: json['supervisor_code'],
      supervisor_branch: json['supervisor_branch']
  );

  Map<String, dynamic> toJson() => {
    "supervisor_id": supervisor_id,
    "supervisor_name": supervisor_name,
    "supervisor_code":supervisor_code
  };
}

