import 'dart:convert';

PaymentListModel paymentListModelFromJson(String str) =>
    PaymentListModel.fromJson(json.decode(str));

String paymentListModelToJson(PaymentListModel data) =>
    json.encode(data.toJson());

class PaymentListModel {
  List<Datum> data;
  bool status;
  String message;

  PaymentListModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory PaymentListModel.fromJson(Map<String, dynamic> json) =>
      PaymentListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        status: json["status"] ?? false,
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class Datum {
  String id;
  String amount;
  String transactionDate;
  String description;
  String collectedById;
  String paymentMethodId;
  String phaseId;
  String phaseName;
  String accountHead;
  String paymentMethod;
  String paidAmount;
  String scheduledAmount;

  Datum({
    required this.id,
    required this.amount,
    required this.transactionDate,
    required this.description,
    required this.collectedById,
    required this.paymentMethodId,
    required this.phaseId,
    required this.phaseName,
    required this.accountHead,
    required this.paymentMethod,
    required this.paidAmount,
    required this.scheduledAmount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"]?.toString() ?? "",
        amount: json["amount"]?.toString() ?? "0",
        transactionDate: json["transaction_date"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        collectedById: json["collected_by_id"]?.toString() ?? "",
        paymentMethodId: json["payment_method_id"]?.toString() ?? "",
        phaseId: json["phase_id"]?.toString() ?? "",
        phaseName: json["phase_name"]?.toString() ?? "",
        accountHead: json["account_head"]?.toString() ?? "",
        paymentMethod: json["payment_method"]?.toString() ?? "",
        paidAmount: json["paid_amount"]?.toString() ?? "0",
        scheduledAmount: json["scheduled_amount"]?.toString() ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "transaction_date": transactionDate,
        "description": description,
        "collected_by_id": collectedById,
        "payment_method_id": paymentMethodId,
        "phase_id": phaseId,
        "phase_name": phaseName,
        "account_head": accountHead,
        "payment_method": paymentMethod,
        "paid_amount": paidAmount,
        "scheduled_amount": scheduledAmount,
      };
}