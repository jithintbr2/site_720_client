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
        data: List<Schedule>.from(json["data"].map((x) => Schedule.fromJson(x))),
        status: json["status"],
        message: json["message"],
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
    String paidAmount;
    String balanceAmount;
    String status;

    Schedule({
        required this.id,
        required this.phaseNo,
        required this.description,
        required this.estCost,
        required this.paidAmount,
        required this.balanceAmount,
        required this.status,
    });

    factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        phaseNo: json["phase_no"],
        description: json["description"],
        estCost: json["est_cost"],
        paidAmount: json["paid_amount"],
        balanceAmount: json["balance_amount"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "phase_no": phaseNo,
        "description": description,
        "est_cost": estCost,
        "paid_amount": paidAmount,
        "balance_amount": balanceAmount,
        "status": status,
    };
}
