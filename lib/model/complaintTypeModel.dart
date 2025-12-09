import 'dart:convert';

class ComplaintTypeModel {
    List<ComplaintType> data;
    bool status;
    String message;

    ComplaintTypeModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory ComplaintTypeModel.fromRawJson(String str) => ComplaintTypeModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ComplaintTypeModel.fromJson(Map<String, dynamic> json) => ComplaintTypeModel(
        data: List<ComplaintType>.from(json["data"].map((x) => ComplaintType.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class ComplaintType {
    String id;
    String name;

    ComplaintType({
        required this.id,
        required this.name,
    });

    factory ComplaintType.fromRawJson(String str) => ComplaintType.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ComplaintType.fromJson(Map<String, dynamic> json) => ComplaintType(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
