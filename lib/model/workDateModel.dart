// To parse this JSON data, do
//
//     final workDatesModel = workDatesModelFromJson(jsonString);

import 'dart:convert';

WorkDatesModel workDatesModelFromJson(Map<String, dynamic> json) => WorkDatesModel.fromJson(json);
String workDatesModelToJson(WorkDatesModel data) => json.encode(data.toJson());
class WorkDatesModel {
    final Data data;
    final bool status;
    final String message;

    WorkDatesModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory WorkDatesModel.fromJson(Map<String, dynamic> json) => WorkDatesModel(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class Data {
    final List<DateTime> workedDays;
    final List<DateTime> nonWorkedDays;

    Data({
        required this.workedDays,
        required this.nonWorkedDays,
    });

     factory Data.fromJson(Map<String, dynamic> json) => Data(
    workedDays: List<DateTime>.from(json["worked_days"].map((x) => DateTime.parse(x))),
    nonWorkedDays: List<DateTime>.from(json["non_worked_days"].map((x) => DateTime.parse(x))),
     );

      Map<String, dynamic> toJson() => {
    "worked_days": List<dynamic>.from(workedDays.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
    "non_worked_days": List<dynamic>.from(nonWorkedDays.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
    };
}
