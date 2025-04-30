class ProfilePageModel {
  bool? status;
  String? message;
  Data? data;

  ProfilePageModel({this.status, this.message, this.data});

  ProfilePageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? clientName;
  String? projectName;
  String? phoneNumber;
  String? place;
  String? description;
  String? estimatedCost;
  String? cctvAddress;
  String? totalCost;
  String? costPending;
  String? workStartDate;
  String? textDetails;
  List<SiteDrawings>? siteDrawings;
  String? workEndDate;
  List<String>? bannerImage;
  List<Gal>? gal;
  List<Video>? video;
  List<Pay>? pay;
  List<Phase>? phase;
  int? totalPercentage;
  List<WorkStep>? workStep;
  List<WorkUpdation>? workUpdation;

  Data(
      {this.clientName,
        this.projectName,
        this.phoneNumber,
        this.place,
        this.description,
        this.estimatedCost,
        this.cctvAddress,
        this.totalCost,
        this.costPending,
        this.workStartDate,
        this.textDetails,
        this.siteDrawings,
        this.workEndDate,
        this.bannerImage,
        this.gal,
        this.video,
        this.pay,
        this.phase,
        this.totalPercentage,
        this.workStep,
        this.workUpdation});

  Data.fromJson(Map<String, dynamic> json) {
    clientName = json['client_name'];
    projectName = json['project_name'];
    phoneNumber = json['phone_number'];
    place = json['place'];
    description = json['description'];
    estimatedCost = json['estimated_cost'];
    cctvAddress = json['cctv_address'];
    totalCost = json['total_cost'];
    costPending = json['cost_pending'];
    workStartDate = json['work_start_date'];
    textDetails = json['text_details'];
    if (json['site_drawings'] != null) {
      siteDrawings = <SiteDrawings>[];
      json['site_drawings'].forEach((v) {
        siteDrawings!.add(SiteDrawings.fromJson(v));
      });
    }
    workEndDate = json['work_end_date'];
    bannerImage = json['banner_image'].cast<String>();
    if (json['gal'] != null) {
      gal = <Gal>[];
      json['gal'].forEach((v) {
        gal!.add(Gal.fromJson(v));
      });
    }
    if (json['video'] != null) {
      video = <Video>[];
      json['video'].forEach((v) {
        video!.add(Video.fromJson(v));
      });
    }
    if (json['pay'] != null) {
      pay = <Pay>[];
      json['pay'].forEach((v) {
        pay!.add(Pay.fromJson(v));
      });
    }
    if (json['phase'] != null) {
      phase = <Phase>[];
      json['phase'].forEach((v) {
        phase!.add(Phase.fromJson(v));
      });
    }
    totalPercentage = json['total_percentage'];
    if (json['work_step'] != null) {
      workStep = <WorkStep>[];
      json['work_step'].forEach((v) {
        workStep!.add(WorkStep.fromJson(v));
      });
    }
    if (json['work_updation'] != null) {
      workUpdation = <WorkUpdation>[];
      json['work_updation'].forEach((v) {
        workUpdation!.add(WorkUpdation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_name'] = clientName;
    data['project_name'] = projectName;
    data['phone_number'] = phoneNumber;
    data['place'] = place;
    data['description'] = description;
    data['estimated_cost'] = estimatedCost;
    data['cctv_address'] = cctvAddress;
    data['total_cost'] = totalCost;
    data['cost_pending'] = costPending;
    data['work_start_date'] = workStartDate;
    data['text_details'] = textDetails;
    if (siteDrawings != null) {
      data['site_drawings'] =
          siteDrawings!.map((v) => v.toJson()).toList();
    }
    data['work_end_date'] = workEndDate;
    data['banner_image'] = bannerImage;
    if (gal != null) {
      data['gal'] = gal!.map((v) => v.toJson()).toList();
    }
    if (video != null) {
      data['video'] = video!.map((v) => v.toJson()).toList();
    }
    if (pay != null) {
      data['pay'] = pay!.map((v) => v.toJson()).toList();
    }
    if (phase != null) {
      data['phase'] = phase!.map((v) => v.toJson()).toList();
    }
    data['total_percentage'] = totalPercentage;
    if (workStep != null) {
      data['work_step'] = workStep!.map((v) => v.toJson()).toList();
    }
    if (workUpdation != null) {
      data['work_updation'] =
          workUpdation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SiteDrawings {
  String? remarks;
  String? imgPath;

  SiteDrawings({this.remarks, this.imgPath});

  SiteDrawings.fromJson(Map<String, dynamic> json) {
    remarks = json['remarks'];
    imgPath = json['img_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remarks'] = remarks;
    data['img_path'] = imgPath;
    return data;
  }
}

class Gal {
  String? phaseNo;
  List<String>? phaseImages;

  Gal({this.phaseNo, this.phaseImages});

  Gal.fromJson(Map<String, dynamic> json) {
    phaseNo = json['phase_no'];
    phaseImages = json['phase_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phase_no'] = phaseNo;
    data['phase_images'] = phaseImages;
    return data;
  }
}

class Video {
  String? phaseNo;
  List<String>? phaseVideo;

  Video({this.phaseNo, this.phaseVideo});

  Video.fromJson(Map<String, dynamic> json) {
    phaseNo = json['phase_no'];
    phaseVideo = json['phase_video'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phase_no'] = phaseNo;
    data['phase_video'] = phaseVideo;
    return data;
  }
}

class Pay {
  String? id;
  String? clientId;
  String? phaseNo;
  String? phaseDescription;
  String? phaseCost;
  String? paidAmount;
  String? balanceAmount;
  String? status;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  

  Pay(
      {this.id,
        this.clientId,
        this.phaseNo,
        this.phaseDescription,
        this.phaseCost,
        this.paidAmount,
        this.balanceAmount,
        this.status,
        this.createdAt,
        this.createdBy,
        this.modifiedAt});

  Pay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    phaseNo = json['phase_no'];
    phaseDescription = json['phase_description'];
    phaseCost = json['phase_cost'];
    paidAmount = json['paid_amount'];
    balanceAmount = json['balance_amount'];
    status = json['status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client_id'] = clientId;
    data['phase_no'] = phaseNo;
    data['phase_description'] = phaseDescription;
    data['phase_cost'] = phaseCost;
    data['paid_amount'] = paidAmount;
    data['balance_amount'] = balanceAmount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    data['modified_at'] = modifiedAt;
    return data;
  }
}

class Phase {
  String? phaseNo;
  String? phaseDescription;
  String? phaseCost;

  Phase({this.phaseNo, this.phaseDescription, this.phaseCost});

  Phase.fromJson(Map<String, dynamic> json) {
    phaseNo = json['phase_no'];
    phaseDescription = json['phase_description'];
    phaseCost = json['phase_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phase_no'] = phaseNo;
    data['phase_description'] = phaseDescription;
    data['phase_cost'] = phaseCost;
    return data;
  }
}

class WorkStep {
  String? fromDate;
  String? toDate;
  bool? isWorked;
  int? percentage;
  String? reason;

  WorkStep(
      {this.fromDate,
        this.toDate,
        this.isWorked,
        this.percentage,
        this.reason});

  WorkStep.fromJson(Map<String, dynamic> json) {
    fromDate = json['from_date'];
    toDate = json['to_date'];
    isWorked = json['isWorked'];
    percentage = json['percentage'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    data['isWorked'] = isWorked;
    data['percentage'] = percentage;
    data['reason'] = reason;
    return data;
  }
}

class WorkUpdation {
  String? workDate;
  String? isWorking;
  int? totalLabours;
  String? description;

  WorkUpdation(
      {this.workDate, this.isWorking, this.totalLabours, this.description});

  WorkUpdation.fromJson(Map<String, dynamic> json) {
    workDate = json['work_date'];
    isWorking = json['is_working'];
    totalLabours = json['total_labours'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['work_date'] = workDate;
    data['is_working'] = isWorking;
    data['total_labours'] = totalLabours;
    data['description'] = description;
    return data;
  }
}