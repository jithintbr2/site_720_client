// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromJson(jsonString);

import 'dart:convert';

HomePageModel homePageModelFromJson(String str) => HomePageModel.fromJson(json.decode(str));

String homePageModelToJson(HomePageModel data) => json.encode(data.toJson());

class HomePageModel {
    bool status;
    String message;
    Data data;

    HomePageModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    List<Banner> banner;
    List<HomeImage> homeImages;

    Data({
        required this.banner,
        required this.homeImages,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        banner: List<Banner>.from(json["banner"].map((x) => Banner.fromJson(x))),
        homeImages: List<HomeImage>.from(json["home_images"].map((x) => HomeImage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
        "home_images": List<dynamic>.from(homeImages.map((x) => x.toJson())),
    };
}

class Banner {
    String id;
    String imageUrl;

    Banner({
        required this.id,
        required this.imageUrl,
    });

    factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["id"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imageUrl,
    };
}

class HomeImage {
    String imgId;
    String imgName;
    String imgUrl;

    HomeImage({
        required this.imgId,
        required this.imgName,
        required this.imgUrl,
    });

    factory HomeImage.fromJson(Map<String, dynamic> json) => HomeImage(
        imgId: json["img_id"],
        imgName: json["img_name"],
        imgUrl: json["img_url"],
    );

    Map<String, dynamic> toJson() => {
        "img_id": imgId,
        "img_name": imgName,
        "img_url": imgUrl,
    };
}
