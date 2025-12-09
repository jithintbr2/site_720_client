class ComplaintDetailResponse {
  bool? status;
  String? message;
  ComplaintDetailData? data;

  ComplaintDetailResponse({this.status, this.message, this.data});

  ComplaintDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ComplaintDetailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ComplaintDetailData {
  String? id;
  String? date;
  String? incidentDate;
  String? customerName;
  String? contactNumber;
  String? description;
  String? mediaUrl;
  String? reportedBy;
  String? complaintType;
  String? complaintNature;
  String? complaintStatus;
  String? reportedByName;
  String? statusName;
  String? complaintTypeName;
  String? complaintNatureName;

  ComplaintDetailData({
    this.id,
    this.date,
    this.incidentDate,
    this.customerName,
    this.contactNumber,
    this.description,
    this.mediaUrl,
    this.reportedBy,
    this.complaintType,
    this.complaintNature,
    this.complaintStatus,
    this.reportedByName,
    this.statusName,
    this.complaintTypeName,
    this.complaintNatureName,
  });

  ComplaintDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    date = json['date'] ?? '';
    incidentDate = json['incident_date'] ?? '';
    customerName = json['customer_name'] ?? '';
    contactNumber = json['contact_number'] ?? '';
    description = json['description'] ?? '';
    mediaUrl = json['media_url'] ?? '';
    reportedBy = json['reported_by']?.toString();
    complaintType = json['complaint_type'] ?? '';
    complaintNature = json['complaint_nature'] ?? '';
    complaintStatus = json['complaint_status']?.toString();
    reportedByName = json['reported_by_name'] ?? '';
    statusName = json['status_name'] ?? '';
    complaintTypeName = json['complaint_type_name'] ?? '';
    complaintNatureName = json['complaint_nature_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'incident_date': incidentDate,
      'customer_name': customerName,
      'contact_number': contactNumber,
      'description': description,
      'media_url': mediaUrl,
      'reported_by': reportedBy,
      'complaint_type': complaintType,
      'complaint_nature': complaintNature,
      'complaint_status': complaintStatus,
      'reported_by_name': reportedByName,
      'status_name': statusName,
      'complaint_type_name': complaintTypeName,
      'complaint_nature_name': complaintNatureName,
    };
  }
}
