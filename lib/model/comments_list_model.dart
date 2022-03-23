import 'dart:convert';

class CommentsListModel {
  // 필드명
  final int? id;
  final String? content;
  final String? createdAt;
  final String? updatedAt;
  final String? firebaseUid;
  final String? googleProfileImage;
  final String? appName;
  final String? user;
  final String? report;

  // 생성자
  CommentsListModel({
    this.id,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.firebaseUid,
    this.googleProfileImage,
    this.appName,
    this.user,
    this.report
  });

  factory CommentsListModel.fromJson(Map<String, dynamic> json) {
    return CommentsListModel(
      id: json["id"] as int,
      content: json["content"] as String,
      createdAt: json["created_at"] as String,
      updatedAt: json["updated_at"] as String,
      firebaseUid: json["firebase_uid"] as String,
      googleProfileImage: json["google_profile_image"] as String,
      appName: json["app_name"] as String,
    );
  }

    Map<String, dynamic> toCommentCreateJSON() {
    return {
      "content": content,
      "user": user,
      "report": report,
    };
  }

  String toCommentCreateJSONString() {
    Map<String, dynamic> userJSON = toCommentCreateJSON();
    String commentCreateJSONString = json.encode(userJSON);

    return commentCreateJSONString;
  }
}
