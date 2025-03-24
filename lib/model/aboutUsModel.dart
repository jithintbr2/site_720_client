class AboutUsModel {
  bool? status;
  String? message;
  Data? data;

  AboutUsModel({this.status, this.message, this.data});

  AboutUsModel.fromJson(Map<String, dynamic> json) {
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
  String? subImage;
  String? companyName;
  String? shortDescription;
  String? overviewTitle;
  String? overviewDescription;
  List<Images>? images;
  List<Services>? services;
  List<String>? video;

  Data(
      {this.mainImage,
        this.subImage,
        this.companyName,
        this.shortDescription,
        this.overviewTitle,
        this.overviewDescription,
        this.images,
        this.services,
        this.video});

  Data.fromJson(Map<String, dynamic> json) {
    mainImage = json['main_image'];
    subImage = json['sub_image'];
    companyName = json['company_name'];
    shortDescription = json['short_description'];
    overviewTitle = json['overview_title'];
    overviewDescription = json['overview_description'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    video = json['video'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_image'] = this.mainImage;
    data['sub_image'] = this.subImage;
    data['company_name'] = this.companyName;
    data['short_description'] = this.shortDescription;
    data['overview_title'] = this.overviewTitle;
    data['overview_description'] = this.overviewDescription;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['video'] = this.video;
    return data;
  }
}

class Images {
  String? image;

  Images({this.image});

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}

class Services {
  String? service;
  String? serviceDescription;

  Services({this.service, this.serviceDescription});

  Services.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    serviceDescription = json['service_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service'] = this.service;
    data['service_description'] = this.serviceDescription;
    return data;
  }
}