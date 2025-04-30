class VillaProjectModel {
  bool? status;
  String? message;
  Data? data;

  VillaProjectModel({this.status, this.message, this.data});

  VillaProjectModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['heading'] = heading;
    data['overview_description'] = overviewDescription;
    data['images'] = images;
    data['youtube_links'] = youtubeLinks;
    return data;
  }
}