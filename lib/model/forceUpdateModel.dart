class ForceUpdateModel {
  bool? status;
  String? message;
  Data? data;

  ForceUpdateModel({this.status, this.message, this.data});

  ForceUpdateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? currentVersion;
  String? minVersion;

  Data({this.id, this.currentVersion, this.minVersion});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentVersion = json['currentVersion'];
    minVersion = json['minVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['currentVersion'] = currentVersion;
    data['minVersion'] = minVersion;
    return data;
  }
}