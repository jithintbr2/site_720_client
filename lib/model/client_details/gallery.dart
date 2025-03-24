// To parse this JSON data, do
//
//     final galleryModel = galleryModelFromJson(jsonString);

import 'dart:convert';

GalleryModel galleryModelFromJson(String str) => GalleryModel.fromJson(json.decode(str));

String galleryModelToJson(GalleryModel data) => json.encode(data.toJson());

class GalleryModel {
    List<Gallery> data;
    bool status;
    String message;

    GalleryModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory GalleryModel.fromJson(Map<String, dynamic> json) => GalleryModel(
        data: List<Gallery>.from(json["data"].map((x) => Gallery.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Gallery {
    String phaseNo;
    List<String> phaseImages;

    Gallery({
        required this.phaseNo,
        required this.phaseImages,
    });

    factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        phaseNo: json["phase_no"],
        phaseImages: List<String>.from(json["phase_images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "phase_no": phaseNo,
        "phase_images": List<dynamic>.from(phaseImages.map((x) => x)),
    };
}
