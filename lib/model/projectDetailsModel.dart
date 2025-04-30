class ProjectDetailsModel {
  bool? status;
  String? message;
  Data? data;

  ProjectDetailsModel({this.status, this.message, this.data});

  ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
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
        imges!.add(Imges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main_image'] = mainImage;
    data['second_image'] = secondImage;
    data['project_name'] = projectName;
    data['starting_at'] = startingAt;
    data['grounf_floor'] = grounfFloor;
    data['first_floor'] = firstFloor;
    data['porch'] = porch;
    data['total_sq_ft'] = totalSqFt;
    data['steel_package'] = steelPackage;
    data['wood_package'] = woodPackage;
    if (imges != null) {
      data['imges'] = imges!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    return data;
  }
}