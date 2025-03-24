// To parse this JSON data, do
//
//     final clientByIdModel = clientByIdModelFromJson(jsonString);

import 'dart:convert';

ClientByIdModel clientByIdModelFromJson(String str) => ClientByIdModel.fromJson(json.decode(str));

String clientByIdModelToJson(ClientByIdModel data) => json.encode(data.toJson());

class ClientByIdModel {
    Data data;
    bool status;
    String message;

    ClientByIdModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory ClientByIdModel.fromJson(Map<String, dynamic> json) => ClientByIdModel(
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
    String clientName;
    String projectName;
    String phoneNumber;
    String place;
    String description;
    String estimatedCost;
    String cctvAddress;
    String totalCost;
    String costPending;
    String workStartDate;
    String workEndDate;
    int totalPercentage;
    String textDetails;
    List<SiteDrawing> siteDrawings;
    List<WorkStep> workStep;

    Data({
        required this.clientName,
        required this.projectName,
        required this.phoneNumber,
        required this.place,
        required this.description,
        required this.estimatedCost,
        required this.cctvAddress,
        required this.totalCost,
        required this.costPending,
        required this.workStartDate,
        required this.workEndDate,
        required this.totalPercentage,
        required this.textDetails,
        required this.siteDrawings,
        required this.workStep,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        clientName: json["client_name"],
        projectName: json["project_name"],
        phoneNumber: json["phone_number"],
        place: json["place"],
        description: json["description"],
        estimatedCost: json["estimated_cost"],
        cctvAddress: json["cctv_address"],
        totalCost: json["total_cost"],
        costPending: json["cost_pending"],
        workStartDate: json["work_start_date"],
        workEndDate: json["work_end_date"],
        totalPercentage: json["total_percentage"],
        textDetails: json["text_details"],
        siteDrawings: List<SiteDrawing>.from(json["site_drawings"].map((x) => SiteDrawing.fromJson(x))),
        workStep: List<WorkStep>.from(json["work_step"].map((x) => WorkStep.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "client_name": clientName,
        "project_name": projectName,
        "phone_number": phoneNumber,
        "place": place,
        "description": description,
        "estimated_cost": estimatedCost,
        "cctv_address": cctvAddress,
        "total_cost": totalCost,
        "cost_pending": costPending,
        "work_start_date": workStartDate,
        "work_end_date": workEndDate,
        "total_percentage": totalPercentage,
        "text_details": textDetails,
        "site_drawings": List<dynamic>.from(siteDrawings.map((x) => x.toJson())),
        "work_step": List<dynamic>.from(workStep.map((x) => x.toJson())),
    };
}

class SiteDrawing {
    String remarks;
    String imgPath;

    SiteDrawing({
        required this.remarks,
        required this.imgPath,
    });

    factory SiteDrawing.fromJson(Map<String, dynamic> json) => SiteDrawing(
        remarks: json["remarks"],
        imgPath: json["img_path"],
    );

    Map<String, dynamic> toJson() => {
        "remarks": remarks,
        "img_path": imgPath,
    };
}

class WorkStep {
    String fromDate;
    String toDate;
    bool isWorked;
    int percentage;
    String reason;

    WorkStep({
        required this.fromDate,
        required this.toDate,
        required this.isWorked,
        required this.percentage,
        required this.reason,
    });

    factory WorkStep.fromJson(Map<String, dynamic> json) => WorkStep(
        fromDate: json["from_date"],
        toDate: json["to_date"],
        isWorked: json["isWorked"],
        percentage: json["percentage"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "from_date": fromDate,
        "to_date": toDate,
        "isWorked": isWorked,
        "percentage": percentage,
        "reason": reason,
    };
}
