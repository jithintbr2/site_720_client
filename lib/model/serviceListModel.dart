class ServiceListModel {
  bool? status;
  String? message;
  List<Data>? data;

  ServiceListModel({this.status, this.message, this.data});

  ServiceListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? serviceId;
  String? serviceTitle;
  String? serviceDescription;

  Data({this.serviceId, this.serviceTitle, this.serviceDescription});

  Data.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceTitle = json['service_title'];
    serviceDescription = json['service_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_title'] = this.serviceTitle;
    data['service_description'] = this.serviceDescription;
    return data;
  }
}