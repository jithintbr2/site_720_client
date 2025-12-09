import 'dart:convert';

class ComplaintReportedByModel {
    List<ComplaintReportedBy> data;
    bool status;
    String message;

    ComplaintReportedByModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory ComplaintReportedByModel.fromRawJson(String str) => ComplaintReportedByModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ComplaintReportedByModel.fromJson(Map<String, dynamic> json) => ComplaintReportedByModel(
        data: List<ComplaintReportedBy>.from(json["data"].map((x) => ComplaintReportedBy.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class ComplaintReportedBy {
    String id;
    String name;

    ComplaintReportedBy({
        required this.id,
        required this.name,
    });

    factory ComplaintReportedBy.fromRawJson(String str) => ComplaintReportedBy.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ComplaintReportedBy.fromJson(Map<String, dynamic> json) => ComplaintReportedBy(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
