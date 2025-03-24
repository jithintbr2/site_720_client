// To parse this JSON data, do
//
//     final getIconsModel = getIconsModelFromJson(jsonString);

import 'dart:convert';

GetIconsModel getIconsModelFromJson(String str) => GetIconsModel.fromJson(json.decode(str));

String getIconsModelToJson(GetIconsModel data) => json.encode(data.toJson());

class GetIconsModel {
    Data data;
    bool status;
    String message;

    GetIconsModel({
        required this.data,
        required this.status,
        required this.message,
    });

    factory GetIconsModel.fromJson(Map<String, dynamic> json) => GetIconsModel(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class Data {
    String bannerImage;
    String clientName;
    String projectName;
    List<IconData> icons;

    Data({
        required this.bannerImage,
        required this.clientName,
        required this.projectName,
        required this.icons,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        bannerImage: json["banner_image"],
        clientName: json["client_name,"],
        projectName: json["project_name,"],
        icons: List<IconData>.from(json["icons"].map((x) => IconData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "client_name,": clientName,
        "project_name,": projectName,
        "icons": List<dynamic>.from(icons.map((x) => x.toJson())),
    };
}

class IconData {
    String iconId;
    String iconName;
    String iconUrl;

    IconData({
        required this.iconId,
        required this.iconName,
        required this.iconUrl,
    });

    factory IconData.fromJson(Map<String, dynamic> json) => IconData(
        iconId: json["icon_id"],
        iconName: json["icon_name"],
        iconUrl: json["icon_url"],
    );

    Map<String, dynamic> toJson() => {
        "icon_id": iconId,
        "icon_name": iconName,
        "icon_url": iconUrl,
    };
}
