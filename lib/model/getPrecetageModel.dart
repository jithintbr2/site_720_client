import 'dart:convert';

class GetPercentModel {
    List<Percentage> data;
    bool status;
    String message;

    GetPercentModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory GetPercentModel.fromRawJson(String str) => GetPercentModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetPercentModel.fromJson(Map<String, dynamic> json) => GetPercentModel(
        data: List<Percentage>.from(json["data"].map((x) => Percentage.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Percentage {
    String stageName;
    int percentComplete;
    String daysLeft;
    String color;

    Percentage({
        required this.stageName,
        required this.percentComplete,
        required this.daysLeft,
        required this.color,
    });

    factory Percentage.fromRawJson(String str) => Percentage.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Percentage.fromJson(Map<String, dynamic> json) => Percentage(
        stageName: json["stage_name"],
        percentComplete: json["percent_complete"],
        daysLeft: json["days_left"],
        color: json["color"],
    );

    Map<String, dynamic> toJson() => {
        "stage_name": stageName,
        "percent_complete": percentComplete,
        "days_left": daysLeft,
        "color": color,
    };
}
