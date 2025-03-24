// To parse this JSON data, do
//
//     final clientWorkStatusModel = clientWorkStatusModelFromJson(jsonString);

import 'dart:convert';

ClientWorkStatusModel clientWorkStatusModelFromJson(String str) => ClientWorkStatusModel.fromJson(json.decode(str));

String clientWorkStatusModelToJson(ClientWorkStatusModel data) => json.encode(data.toJson());

class ClientWorkStatusModel {
    List<WorkUpdation> data;
    bool status;
    String message;

    ClientWorkStatusModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory ClientWorkStatusModel.fromJson(Map<String, dynamic> json) => ClientWorkStatusModel(
        data: List<WorkUpdation>.from(json["data"].map((x) => WorkUpdation.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class WorkUpdation {
  String? workDate;
  String? isWorking;
  int? totalLabours;
  String? description;

  WorkUpdation(
      {this.workDate, this.isWorking, this.totalLabours, this.description});

  WorkUpdation.fromJson(Map<String, dynamic> json) {
    workDate = json['work_date'];
    isWorking = json['is_working'];
    totalLabours = json['total_labours'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['work_date'] = this.workDate;
    data['is_working'] = this.isWorking;
    data['total_labours'] = this.totalLabours;
    data['description'] = this.description;
    return data;
  }
}
