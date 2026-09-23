// To parse this JSON data, do
//
//     final schedulePaymentModel = schedulePaymentModelFromJson(jsonString);

import 'dart:convert';
SchedulePaymentModel schedulePaymentModelFromJson(String str) => SchedulePaymentModel.fromJson(json.decode(str));
String schedulePaymentModelToJson(SchedulePaymentModel data) => json.encode(data.toJson());
class SchedulePaymentModel {
    List<Schedule> data;
    bool status;
    String message;
    SchedulePaymentModel({
        required this.data,
        required this.status,
        required this.message,
    });
    factory SchedulePaymentModel.fromJson(Map<String, dynamic> json) => SchedulePaymentModel(
        data: json["data"] != null ? List<Schedule>.from(json["data"].map((x) => Schedule.fromJson(x))) : [],
        status: json["status"] ?? false,
        message: json["message"]?.toString() ?? "",
    );
    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Schedule {
    String id;
    String phaseNo;
    String description;
    String estCost;
        String totalCost;
        String extraWorkAmount;
            String deductionAmount;
                String percentage;
    String paidAmount;
    String balanceAmount;
    String status;

    Schedule({
        required this.id,
        required this.phaseNo,
        required this.description,
        required this.estCost,
        required this.totalCost,
        required this.extraWorkAmount,
        required this.deductionAmount,
        required this.percentage,
        required this.paidAmount,
        required this.balanceAmount,
        required this.status,
    });

    factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"]?.toString() ?? "",
        phaseNo: json["phase_no"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        estCost: json["est_cost"]?.toString() ?? "",
        totalCost: json["total_cost"]?.toString() ?? "",
        extraWorkAmount: json["extra_work_amount"]?.toString() ?? "",
        deductionAmount: json["deduction_amount"]?.toString() ?? "",
        percentage: json["percentage"]?.toString() ?? "",
        paidAmount: json["paid_amount"]?.toString() ?? "",
        balanceAmount: json["balance_amount"]?.toString() ?? "",
        status: json["status"]?.toString() ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "phase_no": phaseNo,
        "description": description,
        "est_cost": estCost,
        "total_cost": totalCost,
        "extra_work_amount": extraWorkAmount,
        "deduction_amount": deductionAmount,
        "percentage": percentage,
        "paid_amount": paidAmount,
        "balance_amount": balanceAmount,
        "status": status,
    };
}
