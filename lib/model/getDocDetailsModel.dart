import 'dart:convert';

class GetDocsDetails {
    List<Docs> data;
    bool status;
    String message;

    GetDocsDetails({
        required this.data,
        required this.status,
        required this.message,
    });

    factory GetDocsDetails.fromRawJson(String str) => GetDocsDetails.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetDocsDetails.fromJson(Map<String, dynamic> json) => GetDocsDetails(
        data: List<Docs>.from(json["data"].map((x) => Docs.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Docs {
    String id;
    String imgPath;

    Docs({
        required this.id,
        required this.imgPath,
    });

    factory Docs.fromRawJson(String str) => Docs.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Docs.fromJson(Map<String, dynamic> json) => Docs(
        id: json["id"],
        imgPath: json["img_path"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "img_path": imgPath,
    };
}