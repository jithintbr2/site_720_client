// To parse this JSON data, do
//
//     final stageListModel = stageListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

StageListModel stageListModelFromJson(String str) =>
    StageListModel.fromJson(json.decode(str));

String stageListModelToJson(StageListModel data) => json.encode(data.toJson());

class StageListModel {
  List<Datum> data;
  bool status;
  String message;

  StageListModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory StageListModel.fromJson(Map<String, dynamic> json) => StageListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class Datum {
  String id;
  String stageName;
  String daysLeft;
  bool isExpired;
  String stageSts;
  bool isCompleted;
  String startDate;
  String endDate;
  String completedDate;
  String endDateRaw;

  Datum({
    required this.id,
    required this.stageName,
    required this.daysLeft,
    required this.isExpired,
    required this.stageSts,
    required this.isCompleted,
    required this.startDate,
    required this.endDate,
    required this.completedDate,
    required this.endDateRaw,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? "",
        stageName: json["stage_name"] ?? "",
        daysLeft: json["days_left"] ?? "",
        isExpired: json["is_expired"] ?? false,
        stageSts: json["stage_sts"] ?? "",
        isCompleted: json["is_completed"] ?? false,
        startDate: json["start_date"] ?? "",
        endDate: json["end_date"] ?? "",
        completedDate: json["completed_date"] ?? "",
        endDateRaw: json["end_date_raw"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stage_name": stageName,
        "days_left": daysLeft,
        "is_expired": isExpired,
        "stage_sts": stageSts,
        "is_completed": isCompleted,
        "start_date": startDate,
        "end_date": endDate,
        "completed_date": completedDate,
        "end_date_raw": endDateRaw,
      };
}
