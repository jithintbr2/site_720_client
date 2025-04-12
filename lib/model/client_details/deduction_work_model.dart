// To parse this JSON data, do
//
//     final deductionWorkModel = deductionWorkModelFromJson(jsonString);

import 'dart:convert';

DeductionWorkModel deductionWorkModelFromJson(String str) =>
    DeductionWorkModel.fromJson(json.decode(str));

String deductionWorkModelToJson(DeductionWorkModel data) =>
    json.encode(data.toJson());

class DeductionWorkModel {
  List<Datum> data;
  bool status;
  String message;

  DeductionWorkModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory DeductionWorkModel.fromJson(Map<String, dynamic> json) =>
      DeductionWorkModel(
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
  String itemName;
  String itemAmount;
  String description;
  String phaseName;
  String createdAt;

  Datum({
    required this.id,
    required this.itemName,
    required this.itemAmount,
    required this.description,
    required this.phaseName,
    required this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? "",
        itemName: json["work_name"] ?? "",
        itemAmount: json["amount"] ?? "",
        description: json["description"] ?? "",
        phaseName: json["phase_name"] ?? "",
        createdAt: json["created_date"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "work_name": itemName,
        "amount": itemAmount,
        "description": description,
        "phase_name": phaseName,
        "created_date": createdAt,
      };
}
