import 'dart:convert';

ClientByIdModel clientByIdModelFromJson(String str) =>
    ClientByIdModel.fromJson(json.decode(str));

String clientByIdModelToJson(ClientByIdModel data) =>
    json.encode(data.toJson());

class ClientByIdModel {
  Data data;
  bool status;
  String message;

  ClientByIdModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ClientByIdModel.fromJson(Map<String, dynamic> json) =>
      ClientByIdModel(
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
  String receivedFrom;
  String totalExtraWork;
  String totalDeduction;
  String labourWage;
  String cctvAddress;
  String totalCost;
  String costPending;
  String workStartDate;
  String workEndDate;
  String isFreezed;
  String freezedDate;
  String freezedDiff;
  int totalPercentage;
  String textDetails;
  String isFixed;
  String fixedRate;
  List<SiteDrawing> siteDrawings;
  List<WorkStep> workStep;
  List<ProjectInfo> projectInfo;
  ProjectInfoTotal? projectInfoTotal;

  Data({
    required this.clientName,
    required this.projectName,
    required this.phoneNumber,
    required this.place,
    required this.description,
    required this.estimatedCost,
    required this.receivedFrom,
    required this.totalExtraWork,
    required this.totalDeduction,
    required this.labourWage,
    required this.cctvAddress,
    required this.totalCost,
    required this.costPending,
    required this.workStartDate,
    required this.workEndDate,
    required this.isFreezed,
    required this.freezedDate,
    required this.freezedDiff,
    required this.totalPercentage,
    required this.textDetails,
    required this.isFixed,
    required this.fixedRate,
    required this.siteDrawings,
    required this.workStep,
    required this.projectInfo,
    this.projectInfoTotal,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        clientName: json["client_name"] ?? "",
        projectName: json["project_name"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        place: json["place"] ?? "",
        description: json["description"] ?? "",
        estimatedCost: json["estimated_cost"] ?? "",
        receivedFrom: json["received_from_client"] ?? "",
        totalExtraWork: json["total_extra_work"] ?? "",
        totalDeduction: json["total_deduction"] ?? "",
        labourWage: json["labour_wage"] ?? "",
        cctvAddress: json["cctv_address"] ?? "",
        totalCost: json["total_cost"] ?? "",
        costPending: json["cost_pending"] ?? "",
        workStartDate: json["work_start_date"] ?? "",
        workEndDate: json["work_end_date"] ?? "",
        isFreezed: json["is_freezed"] ?? "",
        freezedDate: json["freezed_date"] ?? "",
        freezedDiff: json["freezed_diff"] ?? "",
        totalPercentage: json["total_percentage"] ?? 0,
        textDetails: json["text_details"] ?? "",
        isFixed: json["is_fixed"] ?? "",
        fixedRate: json["fixed_rate"] ?? "",
        siteDrawings: json["site_drawings"] != null
            ? List<SiteDrawing>.from(
                json["site_drawings"].map((x) => SiteDrawing.fromJson(x)))
            : [],
        workStep: json["work_step"] != null
            ? List<WorkStep>.from(
                json["work_step"].map((x) => WorkStep.fromJson(x)))
            : [],
        projectInfo: json["project_info"] != null
            ? List<ProjectInfo>.from(
                json["project_info"].map((x) => ProjectInfo.fromJson(x)))
            : [],
        projectInfoTotal: json["project_info_total"] != null
            ? ProjectInfoTotal.fromJson(json["project_info_total"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "client_name": clientName,
        "project_name": projectName,
        "phone_number": phoneNumber,
        "place": place,
        "description": description,
        "estimated_cost": estimatedCost,
        "received_from_client": receivedFrom,
        "total_extra_work": totalExtraWork,
        "total_deduction": totalDeduction,
        "labour_wage": labourWage,
        "cctv_address": cctvAddress,
        "total_cost": totalCost,
        "cost_pending": costPending,
        "work_start_date": workStartDate,
        "work_end_date": workEndDate,
        "is_freezed": isFreezed,
        "freezed_date": freezedDate,
        "freezed_diff": freezedDiff,
        "total_percentage": totalPercentage,
        "text_details": textDetails,
        "is_fixed": isFixed,
        "fixed_rate": fixedRate,
        "site_drawings":
            List<dynamic>.from(siteDrawings.map((x) => x.toJson())),
        "work_step": List<dynamic>.from(workStep.map((x) => x.toJson())),
        "project_info": List<dynamic>.from(projectInfo.map((x) => x.toJson())),
        "project_info_total": projectInfoTotal?.toJson(),
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
        remarks: json["remarks"] ?? "",
        imgPath: json["img_path"] ?? "",
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
        fromDate: json["from_date"] ?? "",
        toDate: json["to_date"] ?? "",
        isWorked: json["isWorked"] ?? false,
        percentage: json["percentage"] ?? 0,
        reason: json["reason"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "from_date": fromDate,
        "to_date": toDate,
        "isWorked": isWorked,
        "percentage": percentage,
        "reason": reason,
      };
}

class ProjectInfo {
  String sqftName;
  String sqftVal;
  String sqftRate;
  String sqftTotal;

  ProjectInfo({
    required this.sqftName,
    required this.sqftVal,
    required this.sqftRate,
    required this.sqftTotal,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) => ProjectInfo(
        sqftName: json["sqft_name"] ?? "",
        sqftVal: json["sqft_val"] ?? "",
        sqftRate: json["sqft_rate"] ?? "",
        sqftTotal: json["sqft_total"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "sqft_name": sqftName,
        "sqft_val": sqftVal,
        "sqft_rate": sqftRate,
        "sqft_total": sqftTotal,
      };
}

class ProjectInfoTotal {
  String totalSqft;
  String totalAmount;
  String avgRate;

  ProjectInfoTotal({
    required this.totalSqft,
    required this.totalAmount,
    required this.avgRate,
  });

  factory ProjectInfoTotal.fromJson(Map<String, dynamic> json) =>
      ProjectInfoTotal(
        totalSqft: json["total_sqft"] ?? "",
        totalAmount: json["total_amount"] ?? "",
        avgRate: json["avg_rate"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "total_sqft": totalSqft,
        "total_amount": totalAmount,
        "avg_rate": avgRate,
      };
}
