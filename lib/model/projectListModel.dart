class ProjectListModel {
  bool? status;
  String? message;
  Data? data;

  ProjectListModel({this.status, this.message, this.data});

  ProjectListModel.fromJson(Map<String, dynamic> json) {
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
  String? count;
  List<Project>? project;

  Data({this.count, this.project});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['project'] != null) {
      project = <Project>[];
      json['project'].forEach((v) {
        project!.add(Project.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (project != null) {
      data['project'] = project!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['remarks'] = remarks;
    data['project_image'] = projectImage;
    return data;
  }
}