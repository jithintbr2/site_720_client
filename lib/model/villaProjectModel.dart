class VillaProjectModel {
  bool? status;
  String? message;
  Data? data;

  VillaProjectModel({this.status, this.message, this.data});

  VillaProjectModel.fromJson(Map<String, dynamic> json) {
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
  String? heading;
  String? overviewDescription;
  List<String>? images;
  List<String>? youtubeLinks;

  Data(
      {this.heading, this.overviewDescription, this.images, this.youtubeLinks});

  Data.fromJson(Map<String, dynamic> json) {
    heading = json['heading'];
    overviewDescription = json['overview_description'];
    images = json['images'].cast<String>();
    youtubeLinks = json['youtube_links'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['heading'] = this.heading;
    data['overview_description'] = this.overviewDescription;
    data['images'] = this.images;
    data['youtube_links'] = this.youtubeLinks;
    return data;
  }
}