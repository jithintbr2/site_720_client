class ComplaintListModel {
  bool? status;
  String? message;
  List<Data>? data;

  ComplaintListModel({this.status, this.message, this.data});

  ComplaintListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? complaintId;
  String? complaint;
  String? reply;
  String? complaintDate;
  String? repliedDate;

  Data(
      {this.complaintId,
        this.complaint,
        this.reply,
        this.complaintDate,
        this.repliedDate});

  Data.fromJson(Map<String, dynamic> json) {
    complaintId = json['complaint_id'];
    complaint = json['complaint'];
    reply = json['reply'];
    complaintDate = json['complaint_date'];
    repliedDate = json['replied_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['complaint_id'] = complaintId;
    data['complaint'] = complaint;
    data['reply'] = reply;
    data['complaint_date'] = complaintDate;
    data['replied_date'] = repliedDate;
    return data;
  }
}