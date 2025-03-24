// To parse this JSON data, do
//
//     final drawingsModel = drawingsModelFromJson(jsonString);

import 'dart:convert';

DrawingsModel drawingsModelFromJson(String str) => DrawingsModel.fromJson(json.decode(str));

String drawingsModelToJson(DrawingsModel data) => json.encode(data.toJson());

class DrawingsModel {
    List<Drawings> data;
    bool status;
    String message;

    DrawingsModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory DrawingsModel.fromJson(Map<String, dynamic> json) => DrawingsModel(
        data: List<Drawings>.from(json["data"].map((x) => Drawings.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Drawings {
    String remarks;  
    String imgPath; 

    Drawings({
        required this.remarks,
        required this.imgPath,
    });

    factory Drawings.fromJson(Map<String, dynamic> json) => Drawings(
        remarks: json["remarks"],
        imgPath: json["img_path"],
    );

    Map<String, dynamic> toJson() => {
        "remarks": remarks,
        "img_path": imgPath,
    };
}
