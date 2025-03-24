class PushNotificationModel {
  String? title;
  String? message;
  String? type;
  int? notificationId;
  int? detailId;
  int? detailParentId;
  PushNotificationModel({this.title,this.message,this.type,this.detailId,this.detailParentId,this.notificationId});
  PushNotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    type = json['type'];
    notificationId = json['notificationId'];
    detailId = json['detailId'];
    detailParentId = json['detailParentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['type'] = this.type;
    data['notificationId'] = this.notificationId;
    data['detailId'] = this.detailId;
    data['detailParentId'] = this.detailParentId;
    return data;
  }
}




