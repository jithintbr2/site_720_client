import 'dart:convert';

class GetCountLabours {
    List<LaboursCount> data;
    bool status;
    String message;

    GetCountLabours({
        required this.data,
        required this.status,
        required this.message,
    });

    factory GetCountLabours.fromRawJson(String str) => GetCountLabours.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetCountLabours.fromJson(Map<String, dynamic> json) => GetCountLabours(
        data: List<LaboursCount>.from(json["data"].map((x) => LaboursCount.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class LaboursCount {
    String laboursNo;
    String workDate;

    LaboursCount({
        required this.laboursNo,
        required this.workDate,
    });

    factory LaboursCount.fromRawJson(String str) => LaboursCount.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LaboursCount.fromJson(Map<String, dynamic> json) => LaboursCount(
        laboursNo: json["labours_no"]??"",
        workDate: json["work_date"]??"",
    );

    Map<String, dynamic> toJson() => {
        "labours_no": laboursNo,
        "work_date": workDate,
    };
}