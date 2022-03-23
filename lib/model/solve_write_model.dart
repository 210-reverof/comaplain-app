import 'dart:convert';

class SolveWriteModel {
  // 필드명
  final String? solvedUser;
  final String? solvedGoogleProfileImage;
  final String? solvedAppName;
  final String? solvedTitle;
  final String? solvedExplanation;
  final int? solved;
  final String ? solvedCreatedAt;

  // 생성자
  SolveWriteModel(
      {this.solvedUser,
      this.solvedGoogleProfileImage,
      this.solvedAppName,
      this.solvedTitle,
      this.solvedExplanation,
      this.solved,
      this.solvedCreatedAt});

  factory SolveWriteModel.fromJson(Map<String, dynamic> json) {
    return SolveWriteModel(
      solvedUser: json["solved_user"] as String,
      solvedGoogleProfileImage: json["solved_google_profile_image"] as String,
      solvedAppName: json["solved_app_name"] as String,
      solvedTitle: json["solved_title"] as String,
      solvedExplanation: json["solved_explanation"] as String,
      solved: json["solved"] as int,
      solvedCreatedAt: json["solved_created_at"] as String ,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "solved_user": solvedUser,
      "solved_google_profile_image": solvedGoogleProfileImage,
      "solved_app_name": solvedAppName,
      "solved_title": solvedTitle,
      "solved_explanation": solvedExplanation,
      "solved": solved,
      "solved_created_at": solvedCreatedAt,
    };
  }

  String toJSONString() {
    Map<String, dynamic> userJSON = toMap();
    String jsonSting = json.encode(userJSON);

    return jsonSting;
  }
}
