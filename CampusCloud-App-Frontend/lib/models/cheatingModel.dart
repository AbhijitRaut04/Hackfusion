class CheatingModel {
  String? sId;
  Student? student;
  String? title;
  String? description;
  List<String>? proof;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CheatingModel(
      {this.sId,
        this.student,
        this.title,
        this.description,
        this.proof,
        this.createdAt,
        this.updatedAt,
        this.iV});

  CheatingModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    student =
    json['student'] != null ? new Student.fromJson(json['student']) : null;
    title = json['title'];
    description = json['description'];
    proof = json['proof'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (student != null) {
      data['student'] = student!.toJson();
    }
    data['title'] = this.title;
    data['description'] = description;
    data['proof'] = proof;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Student {
  String? sId;
  String? name;
  String? email;

  Student({this.sId, this.name, this.email});

  Student.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
