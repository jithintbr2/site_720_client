// To parse this JSON data, do
//
//     final packageModel = packageModelFromJson(jsonString);

import 'dart:convert';

PackageModel packageModelFromJson(String str) => PackageModel.fromJson(json.decode(str));

String packageModelToJson(PackageModel data) => json.encode(data.toJson());

class PackageModel {
    Data data;
    bool status;
    String message;

    PackageModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
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
    String id;
    String packageName;
    String description;

    Data({
        required this.id,
        required this.packageName,
        required this.description,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        packageName: json["package_name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "package_name": packageName,
        "description": description,
    };
}
