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
  String amount;
  String transactionDate;
  String description;
  String collectedById;
  String paymentMethodId;
  String phaseId;
  String phaseName;
  String accountHead;
  String paymentMethod;

  Datum({
    required this.amount,
    required this.transactionDate,
    required this.description,
    required this.collectedById,
    required this.paymentMethodId,
    required this.phaseId,
    required this.phaseName,
    required this.accountHead,
    required this.paymentMethod,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        amount: json["amount"]??"",
        transactionDate: json["transaction_date"]??"",
        description: json["description"]??"",
        collectedById: json["collected_by_id"]??"",
        paymentMethodId: json["payment_method_id"]??"",
        phaseId: json["phase_id"]??"",
        phaseName: json["phase_name"]??"",
        accountHead: json["account_head"]??"",
        paymentMethod: json["payment_method"]??"",
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "transaction_date": transactionDate,
        "description": description,
        "collected_by_id": collectedById,
        "payment_method_id": paymentMethodId,
        "phase_id": phaseId,
        "phase_name": phaseName,
        "account_head": accountHead,
        "payment_method": paymentMethod,
      };
}
