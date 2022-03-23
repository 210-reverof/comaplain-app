class ReportDetailBodyModel {
  // 필드명
  final int? id;
  final String? title;
  final String? explanation;
  final String? solvedTitle;
  final String? solvedExplanation;
  final num? latitude;
  final num? longitude;
  final int? recommendation;
  final int? solved;
  final String? createdAt;
  final String? updatedAt;
  final String? solvedCreatedAt;
  final String? solvedUpdatedAt;
  final String? user;
  final String? appName;
  final String? googleProfileImage;
  final String? solvedUser;
  final String? solvedGoogleProfileImage;
  final String? solvedAppName;
  final int? category;

  // 생성자
  ReportDetailBodyModel({
    this.id,
    this.title,
    this.explanation,
    this.solvedTitle,
    this.solvedExplanation,
    this.latitude,
    this.longitude,
    this.recommendation,
    this.solved,
    this.createdAt,
    this.updatedAt,
    this.solvedCreatedAt,
    this.solvedUpdatedAt,
    this.user,
    this.appName,
    this.googleProfileImage,
    this.solvedUser,
    this.solvedGoogleProfileImage,
    this.solvedAppName,
    this.category,
  });

  factory ReportDetailBodyModel.fromJson(Map<String, dynamic> json) {
    return ReportDetailBodyModel(
      id: json["id"] as int,
      title: json["title"] as String,
      explanation: json["explanation"] as String,
      solvedTitle: json["solved_title"] as String,
      solvedExplanation: json["solved_explanation"] as String,
      latitude: json["latitude"] as num,
      longitude: json["longitude"] as num,
      recommendation: json["recommendation"] as int,
      solved: json["solved"] as int,
      createdAt: json["created_at"] as String,
      updatedAt: json["updated_at"] as String,
      solvedCreatedAt: json["solved_created_at"] as String,
      solvedUpdatedAt: json["solved_updated_at"] as String,
      user: json["user"] as String,
      appName: json["app_name"] as String,
      googleProfileImage: json["google_profile_image"] as String,
      solvedUser: json["solved_user"] as String,
      solvedGoogleProfileImage: json["solved_google_profile_image"] as String,
      solvedAppName: json["solved_app_name"] as String,
      category: json["category"] as int,
    );
  }
}
