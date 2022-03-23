import 'dart:convert';

class CommentsCreateModel {
  // 필드명
  final String? content;
  final String? user;
  final int? report;

  // 생성자
  CommentsCreateModel({this.content, this.user, this.report});

  factory CommentsCreateModel.fromJson(Map<String, dynamic> json) {
    return CommentsCreateModel(
      content: json["content"] as String,
      user: json["user"] as String,
      report: json["report"] as int,
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
