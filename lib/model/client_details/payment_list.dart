// To parse this JSON data, do
//
//     final paymentListModel = paymentListModelFromJson(jsonString);

import 'dart:convert';

PaymentListModel paymentListModelFromJson(String str) => PaymentListModel.fromJson(json.decode(str));

String paymentListModelToJson(PaymentListModel data) => json.encode(data.toJson());

class PaymentListModel {
    List<Datum> data;
    bool status;
    String message;

    PaymentListModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory PaymentListModel.fromJson(Map<String, dynamic> json) => PaymentListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Datum {
    String paidDate;
    String paidAmount;
    String description;

    Datum({
        required this.paidDate,
        required this.paidAmount,
        required this.description,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        paidDate: json["paid_date"],
        paidAmount: json["paid_amount"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "paid_date": paidDate,
        "paid_amount": paidAmount,
        "description": description,
    };
}
