// emi_list_model.dart
class EmiListResponse {
  bool status;
  String message;
  List<EmiData> data;

  EmiListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EmiListResponse.fromJson(Map<String, dynamic> json) {
    return EmiListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<EmiData>.from(
              json['data'].map((x) => EmiData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((x) => x.toJson()).toList(),
      };
}

class EmiData {
  String id;
  String installmentAmount;
  String installmentDate;
  String status;

  EmiData({
    required this.id,
    required this.installmentAmount,
    required this.installmentDate,
    required this.status,
  });

  factory EmiData.fromJson(Map<String, dynamic> json) {
    return EmiData(
      id: json['id'] ?? '',
      installmentAmount: json['installment_amount'] ?? '',
      installmentDate: json['installment_date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'installment_amount': installmentAmount,
        'installment_date': installmentDate,
        'status': status,
      };
}
