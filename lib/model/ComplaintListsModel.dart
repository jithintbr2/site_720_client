class ComplaintListResponse {
  bool? status;
  String? message;
  List<ComplaintData>? data;

  ComplaintListResponse({this.status, this.message, this.data});

  ComplaintListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ComplaintData>[];
      json['data'].forEach((v) {
        data!.add(ComplaintData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class ComplaintData {
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
  List<TaskHistory>? taskHistory;

  ComplaintData({
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
    this.taskHistory,
  });

  ComplaintData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    incidentDate = json['incident_date'];
    customerName = json['customer_name'];
    contactNumber = json['contact_number'];
    description = json['description'];
    mediaUrl = json['media_url'];
    reportedBy = json['reported_by'];
    complaintType = json['complaint_type'];
    complaintNature = json['complaint_nature'];
    complaintStatus = json['complaint_status'];
    reportedByName = json['reported_by_name'];
    statusName = json['status_name'];
    complaintTypeName = json['complaint_type_name'];
    complaintNatureName = json['complaint_nature_name'];
    if (json['task_history'] != null) {
      taskHistory = <TaskHistory>[];
      json['task_history'].forEach((v) {
        taskHistory!.add(TaskHistory.fromJson(v));
      });
    }
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
      'task_history': taskHistory?.map((v) => v.toJson()).toList(),
    };
  }
}

class TaskHistory {
  String? id;
  String? comment;
  String? createdAt;
  List<TaskFile>? files;

  TaskHistory({this.id, this.comment, this.createdAt, this.files});

  TaskHistory.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    comment = json['comment'];
    createdAt = json['created_at'];
    if (json['files'] != null) {
      files = <TaskFile>[];
      json['files'].forEach((v) {
        files!.add(TaskFile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['created_at'] = createdAt;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskFile {
  String? id;
  String? filename;
  String? fileSize;
  String? mediaUrl;
  String? type;

  TaskFile({this.id, this.filename, this.fileSize, this.mediaUrl, this.type});

  TaskFile.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    filename = json['filename'];
    fileSize = json['file_size']?.toString();
    mediaUrl = json['media_url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['filename'] = filename;
    data['file_size'] = fileSize;
    data['media_url'] = mediaUrl;
    data['type'] = type;
    return data;
  }
}
