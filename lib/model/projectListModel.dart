class ProjectListModel {
  bool? status;
  String? message;
  Data? data;

  ProjectListModel({this.status, this.message, this.data});

  ProjectListModel.fromJson(Map<String, dynamic> json) {
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
  String? count;
  List<Project>? project;

  Data({this.count, this.project});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['project'] != null) {
      project = <Project>[];
      json['project'].forEach((v) {
        project!.add(new Project.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.project != null) {
      data['project'] = this.project!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Project {
  String? id;
  String? name;
  String? remarks;
  String? projectImage;

  Project({this.id, this.name, this.remarks, this.projectImage});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    remarks = json['remarks'];
    projectImage = json['project_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['remarks'] = this.remarks;
    data['project_image'] = this.projectImage;
    return data;
  }
}