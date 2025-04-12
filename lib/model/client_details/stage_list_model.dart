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
  String stageId;
  String stageName;
  String estDays;
  String stageStatus;
  String startDate;
  String endDate;
  List<WorkDetail> workDetails;
  Datum({
    required this.stageId,
    required this.stageName,
    required this.estDays,
    required this.stageStatus,
    required this.startDate,
    required this.endDate,
    required this.workDetails,
  });
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        stageId: json["stage_id"] ?? "",
        stageName: json["stage_name"] ?? "",
        estDays: json["est_days"] ?? "",
        stageStatus: json["stage_status"] ?? "",
        startDate: json["start_date"] ?? "",
        endDate: json["end_date"] ?? "",
        workDetails: json["work_details"] == null
            ? []
            : List<WorkDetail>.from(
                json["work_details"].map((x) => WorkDetail.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "stage_id": stageId,
        "stage_name": stageName,
        "est_days": estDays,
        "stage_status": stageStatus,
        "start_date": startDate,
        "end_date": endDate,
        "work_details": List<dynamic>.from(workDetails.map((x) => x.toJson())),
      };
}
class WorkDetail {
  String isWorking;
  String workDate;
  String laboursNo;
  String workStatusId;
  String workStatus;
  String description;
  WorkDetail({
    required this.isWorking,
    required this.workDate,
    required this.laboursNo,
    required this.workStatusId,
    required this.workStatus,
    required this.description,
  });
  factory WorkDetail.fromJson(Map<String, dynamic> json) => WorkDetail(
        isWorking: json["is_working"] ?? "",
        workDate: json["work_date"] ?? "",
        laboursNo: json["labours_no"] ?? "",
        workStatusId: json["work_status_id"] ?? "",
        workStatus: json["work_status"] ?? "",
        description: json["description"] ?? "",
      );
  Map<String, dynamic> toJson() => {
        "is_working": isWorking,
        "work_date": workDate,
        "labours_no": laboursNo,
        "work_status_id": workStatusId,
        "work_status": workStatus,
        "description": description,
      };
}

