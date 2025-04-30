class BhkFilterListModel {
  bool? status;
  String? message;
  List<String>? data;

  BhkFilterListModel({this.status, this.message, this.data});

  BhkFilterListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}