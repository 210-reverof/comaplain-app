import 'dart:convert';

class ReportRecommendationCreateModel {
  // 필드명
  final String? user;
  final int? report;

  // 생성자
  ReportRecommendationCreateModel({this.user, this.report});

  factory ReportRecommendationCreateModel.fromJson(Map<String, dynamic> json) {
    return ReportRecommendationCreateModel(
      user: json["user"] as String,
      report: json["report"] as int,
    );
  }

  Map<String, dynamic> toReportRecommendationCreateJSON() {
    return {
      "user": user,
      "report": report,
    };
  }

  String toReportRecommendationCreateJSONString() {
    Map<String, dynamic> userJSON = toReportRecommendationCreateJSON();
    String commentCreateJSONString = json.encode(userJSON);

    return commentCreateJSONString;
  }
}
