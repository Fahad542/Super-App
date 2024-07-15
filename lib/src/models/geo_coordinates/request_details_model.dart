class Request_details_model{
  List<Request_details_data>? data;

  Request_details_model({this.data});

  Request_details_model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Request_details_data>[];
      json['data'].forEach((v) {
        data!.add(new Request_details_data.fromJson(v));
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

class Request_details_data {
  String? request_id;
  String? dsf_latitude;
  String? dsf_longitude;
  String? original_latitude;
  String? original_longitude;

  Request_details_data({this.request_id, this.dsf_latitude, this.dsf_longitude, this.original_latitude, this.original_longitude,


  });

  Request_details_data.fromJson(Map<String, dynamic> json) {
    request_id = json['request_id'];
    dsf_latitude = json['dsf_latitude'];
    dsf_longitude = json['dsf_longitude'];
    original_longitude = json['original_longitude'];
    original_latitude = json['original_latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.request_id;
    data['dsf_latitude'] = this.dsf_latitude;
    data['dsf_longitude'] = this.dsf_longitude;
    data['original_longitude'] = this.original_longitude;
    data['original_latitude'] = this.original_latitude;
    return data;
  }
}