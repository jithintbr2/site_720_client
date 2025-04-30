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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['message'] = message;
    data['type'] = type;
    data['notificationId'] = notificationId;
    data['detailId'] = detailId;
    data['detailParentId'] = detailParentId;
    return data;
  }
}




