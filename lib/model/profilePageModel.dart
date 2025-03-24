class ProfilePageModel {
  bool? status;
  String? message;
  Data? data;

  ProfilePageModel({this.status, this.message, this.data});

  ProfilePageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
        siteDrawings!.add(new SiteDrawings.fromJson(v));
      });
    }
    workEndDate = json['work_end_date'];
    bannerImage = json['banner_image'].cast<String>();
    if (json['gal'] != null) {
      gal = <Gal>[];
      json['gal'].forEach((v) {
        gal!.add(new Gal.fromJson(v));
      });
    }
    if (json['video'] != null) {
      video = <Video>[];
      json['video'].forEach((v) {
        video!.add(new Video.fromJson(v));
      });
    }
    if (json['pay'] != null) {
      pay = <Pay>[];
      json['pay'].forEach((v) {
        pay!.add(new Pay.fromJson(v));
      });
    }
    if (json['phase'] != null) {
      phase = <Phase>[];
      json['phase'].forEach((v) {
        phase!.add(new Phase.fromJson(v));
      });
    }
    totalPercentage = json['total_percentage'];
    if (json['work_step'] != null) {
      workStep = <WorkStep>[];
      json['work_step'].forEach((v) {
        workStep!.add(new WorkStep.fromJson(v));
      });
    }
    if (json['work_updation'] != null) {
      workUpdation = <WorkUpdation>[];
      json['work_updation'].forEach((v) {
        workUpdation!.add(new WorkUpdation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_name'] = this.clientName;
    data['project_name'] = this.projectName;
    data['phone_number'] = this.phoneNumber;
    data['place'] = this.place;
    data['description'] = this.description;
    data['estimated_cost'] = this.estimatedCost;
    data['cctv_address'] = this.cctvAddress;
    data['total_cost'] = this.totalCost;
    data['cost_pending'] = this.costPending;
    data['work_start_date'] = this.workStartDate;
    data['text_details'] = this.textDetails;
    if (this.siteDrawings != null) {
      data['site_drawings'] =
          this.siteDrawings!.map((v) => v.toJson()).toList();
    }
    data['work_end_date'] = this.workEndDate;
    data['banner_image'] = this.bannerImage;
    if (this.gal != null) {
      data['gal'] = this.gal!.map((v) => v.toJson()).toList();
    }
    if (this.video != null) {
      data['video'] = this.video!.map((v) => v.toJson()).toList();
    }
    if (this.pay != null) {
      data['pay'] = this.pay!.map((v) => v.toJson()).toList();
    }
    if (this.phase != null) {
      data['phase'] = this.phase!.map((v) => v.toJson()).toList();
    }
    data['total_percentage'] = this.totalPercentage;
    if (this.workStep != null) {
      data['work_step'] = this.workStep!.map((v) => v.toJson()).toList();
    }
    if (this.workUpdation != null) {
      data['work_updation'] =
          this.workUpdation!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remarks'] = this.remarks;
    data['img_path'] = this.imgPath;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phase_no'] = this.phaseNo;
    data['phase_images'] = this.phaseImages;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phase_no'] = this.phaseNo;
    data['phase_video'] = this.phaseVideo;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['phase_no'] = this.phaseNo;
    data['phase_description'] = this.phaseDescription;
    data['phase_cost'] = this.phaseCost;
    data['paid_amount'] = this.paidAmount;
    data['balance_amount'] = this.balanceAmount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['modified_at'] = this.modifiedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phase_no'] = this.phaseNo;
    data['phase_description'] = this.phaseDescription;
    data['phase_cost'] = this.phaseCost;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['isWorked'] = this.isWorked;
    data['percentage'] = this.percentage;
    data['reason'] = this.reason;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['work_date'] = this.workDate;
    data['is_working'] = this.isWorking;
    data['total_labours'] = this.totalLabours;
    data['description'] = this.description;
    return data;
  }
}