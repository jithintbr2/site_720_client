class ProjectDetailsModel {
  bool? status;
  String? message;
  Data? data;

  ProjectDetailsModel({this.status, this.message, this.data});

  ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? mainImage;
  String? secondImage;
  String? projectName;
  String? startingAt;
  String? grounfFloor;
  String? firstFloor;
  String? porch;
  String? totalSqFt;
  String? steelPackage;
  String? woodPackage;
  List<Imges>? imges;

  Data(
      {this.mainImage,
        this.secondImage,
        this.projectName,
        this.startingAt,
        this.grounfFloor,
        this.firstFloor,
        this.porch,
        this.totalSqFt,
        this.steelPackage,
        this.woodPackage,
        this.imges});

  Data.fromJson(Map<String, dynamic> json) {
    mainImage = json['main_image'];
    secondImage = json['second_image'];
    projectName = json['project_name'];
    startingAt = json['starting_at'];
    grounfFloor = json['grounf_floor'];
    firstFloor = json['first_floor'];
    porch = json['porch'];
    totalSqFt = json['total_sq_ft'];
    steelPackage = json['steel_package'];
    woodPackage = json['wood_package'];
    if (json['imges'] != null) {
      imges = <Imges>[];
      json['imges'].forEach((v) {
        imges!.add(new Imges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_image'] = this.mainImage;
    data['second_image'] = this.secondImage;
    data['project_name'] = this.projectName;
    data['starting_at'] = this.startingAt;
    data['grounf_floor'] = this.grounfFloor;
    data['first_floor'] = this.firstFloor;
    data['porch'] = this.porch;
    data['total_sq_ft'] = this.totalSqFt;
    data['steel_package'] = this.steelPackage;
    data['wood_package'] = this.woodPackage;
    if (this.imges != null) {
      data['imges'] = this.imges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Imges {
  String? image;

  Imges({this.image});

  Imges.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}