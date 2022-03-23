import 'dart:convert';

class ReportWriteModel {
  // 필드명
  final String? title;
  final String? explanation;
  final num? latitude;
  final num? longitude;
  final int? recommendation;
  final int? solved;
  final String? user;
  final String? solvedUser;

  final int? category;

  // 생성자
  ReportWriteModel({
    this.title,
    this.explanation,
    this.latitude,
    this.longitude,
    this.recommendation,
    this.solved,
    this.user,
    this.solvedUser,
    this.category,
  });

  factory ReportWriteModel.fromJson(Map<String, dynamic> json) {
    return ReportWriteModel(
      title: json["title"] as String,
      explanation: json["explanation"] as String,
      latitude: json["latitude"] as num,
      longitude: json["longitude"] as num,
      recommendation: json["recommendation"] as int,
      solved: json["solved"] as int,
      user: json["user"] as String,
      solvedUser: json["solved_user"] as String,
      category: json["category"] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "explanation": explanation,
      "latitude": latitude,
      "longitude": longitude,
      "recommendation": recommendation,
      "solved": solved,
      "user": user,
      "solved_user": solvedUser,
      "category": category,
    };
  }

  String toJSONString() {
    Map<String, dynamic> userJSON = toMap();
    String jsonSting = json.encode(userJSON);

    return jsonSting;
  }
}
