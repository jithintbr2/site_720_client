// To parse this JSON data, do
//
//     final phaseVideoModel = phaseVideoModelFromJson(jsonString);

import 'dart:convert';

PhaseVideoModel phaseVideoModelFromJson(String str) => PhaseVideoModel.fromJson(json.decode(str));

String phaseVideoModelToJson(PhaseVideoModel data) => json.encode(data.toJson());

class PhaseVideoModel {
    List<Videos> data;
    bool status;
    String message;

    PhaseVideoModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory PhaseVideoModel.fromJson(Map<String, dynamic> json) => PhaseVideoModel(
        data: List<Videos>.from(json["data"].map((x) => Videos.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Videos {
    String phaseNo;
    List<String> phaseVideo;

    Videos({
        required this.phaseNo,
        required this.phaseVideo,
    });

    factory Videos.fromJson(Map<String, dynamic> json) => Videos(
        phaseNo: json["phase_no"],
        phaseVideo: List<String>.from(json["phase_video"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "phase_no": phaseNo,
        "phase_video": List<dynamic>.from(phaseVideo.map((x) => x)),
    };
}
