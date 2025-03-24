// To parse this JSON data, do
//
//     final extraWorkModel = extraWorkModelFromJson(jsonString);

import 'dart:convert';

ExtraWorkModel extraWorkModelFromJson(String str) => ExtraWorkModel.fromJson(json.decode(str));

String extraWorkModelToJson(ExtraWorkModel data) => json.encode(data.toJson());

class ExtraWorkModel {
    List<Datum> data;
    bool status;
    String message;

    ExtraWorkModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory ExtraWorkModel.fromJson(Map<String, dynamic> json) => ExtraWorkModel(
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

    Datum({
        required this.id,
        required this.itemName,
        required this.itemAmount,
        required this.description,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        itemName: json["item_name"],
        itemAmount: json["item_amount"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "item_name": itemName,
        "item_amount": itemAmount,
        "description": description,
    };
}
