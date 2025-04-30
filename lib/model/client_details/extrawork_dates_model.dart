// To parse this JSON data, do
//
//     final extraworkDates = extraworkDatesFromJson(jsonString);

import 'dart:convert';

ExtraworkDates extraworkDatesFromJson(String str) => ExtraworkDates.fromJson(json.decode(str));

String extraworkDatesToJson(ExtraworkDates data) => json.encode(data.toJson());

class ExtraworkDates {
    final List<ExtraDate> data;
    final bool status;
    final String message;

    ExtraworkDates({
        required this.data,
        required this.status,
        required this.message,
    });

    factory ExtraworkDates.fromJson(Map<String, dynamic> json) => ExtraworkDates(
        data: List<ExtraDate>.from(json["data"].map((x) => ExtraDate.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class ExtraDate {
    final String workDate;
    final String isWorking;
    final String description;
    final String workStatusOrLabourNo;
    final String stageName;
    final String projectName;

    ExtraDate({
        required this.workDate,
        required this.isWorking,
        required this.description,
        required this.workStatusOrLabourNo,
        required this.stageName,
        required this.projectName,
    });

    factory ExtraDate.fromJson(Map<String, dynamic> json) => ExtraDate(
        workDate: json["work_date"],
        isWorking: json["is_working"],
        description: json["description"],
        workStatusOrLabourNo: json["work_status_or_labour_no"],
        stageName: json["stage_name"],
        projectName: json["project_name"],
    );

    Map<String, dynamic> toJson() => {
        "work_date": workDate,
        "is_working": isWorking,
        "description": description,
        "work_status_or_labour_no": workStatusOrLabourNo,
        "stage_name": stageName,
        "project_name": projectName,
    };
}
