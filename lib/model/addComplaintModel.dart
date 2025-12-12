class AddComplaintModel {
  final bool status;
  final String message;
  final bool data;

  AddComplaintModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddComplaintModel.fromJson(Map<String, dynamic> json) {
    return AddComplaintModel(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] ?? false,
    );
  }
}
