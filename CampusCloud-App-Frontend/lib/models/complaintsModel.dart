class ComplaintsModel {
  String? sId;
  String? title;
  List<String>? complaintTo;
  String? description;
  Map<String, dynamic>? student;
  int? keepAnonymousCount;
  String? status;
  List<String>? attachments;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ComplaintsModel(
      {this.sId,
        this.title,
        this.complaintTo,
        this.description,
        this.student,
        this.keepAnonymousCount,
        this.status,
        this.attachments,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ComplaintsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    complaintTo = json['complaintTo'].cast<String>();
    description = json['description'];
    student = json['student'];
    keepAnonymousCount = json['keepAnonymousCount'];
    status = json['status'];
    attachments = json['attachments'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['complaintTo'] = complaintTo;
    data['description'] = description;
    data['student'] = student;
    data['keepAnonymousCount'] = keepAnonymousCount;
    data['status'] = status;
    data['attachments'] = attachments;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
