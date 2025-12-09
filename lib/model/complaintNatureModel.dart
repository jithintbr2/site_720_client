import 'dart:convert';

class ComplaintNatureModel {
    List<ComplaintNature> data;
    bool status;
    String message;

    ComplaintNatureModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory ComplaintNatureModel.fromRawJson(String str) => ComplaintNatureModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ComplaintNatureModel.fromJson(Map<String, dynamic> json) => ComplaintNatureModel(
        data: List<ComplaintNature>.from(json["data"].map((x) => ComplaintNature.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class ComplaintNature {
    String id;
    String name;

    ComplaintNature({
        required this.id,
        required this.name,
    });

    factory ComplaintNature.fromRawJson(String str) => ComplaintNature.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ComplaintNature.fromJson(Map<String, dynamic> json) => ComplaintNature(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
