class ReportGetModel {
  // 필드명
  final int? id;
  final String? title;
  final String? explanation;
  final String? solvedTitle;
  final String? solvedExplanation;
  final num? latitude;
  final num? longitude;
  final int? recommendation;
  final bool? solved;
  final String? solvedUser;
  final String? solvedGoogleProfileImage;
  final String? solvedAppName;
  final String? createdAt;
  final String? updatedAt;
  final String? solvedCreatedAt;
  final String? solvedUpdatedAt;
  final String? user;
  final int? category;

  // 생성자
  ReportGetModel({
    this.id,
    this.title,
    this.explanation,
    this.solvedTitle,
    this.solvedExplanation,
    this.latitude,
    this.longitude,
    this.recommendation,
    this.solved,
    this.solvedUser,
    this.solvedGoogleProfileImage,
    this.solvedAppName,
    this.createdAt,
    this.updatedAt,
    this.solvedCreatedAt,
    this.solvedUpdatedAt,
    this.user,
    this.category,
  });

  factory ReportGetModel.fromJson(Map<String, dynamic> json) {
    return ReportGetModel(
      id: json["id"] as int,
      title: json["title"] as String,
      explanation: json["explanation"] as String,
      solvedTitle: json["solved_title"],
      solvedExplanation: json["solved_explanation"],
      latitude: json["latitude"] as num,
      longitude: json["longitude"] as num,
      recommendation: json["recommendation"] as int,
      solved: json["solved"] as bool,
      solvedUser: json["solved_user"],
      solvedGoogleProfileImage: json["solved_google_profile_image"],
      solvedAppName: json["solved_app_name"],
      createdAt: json["created_at"] as String,
      updatedAt: json["updated_at"] as String,
      solvedCreatedAt: json["solved_created_at"] as String,
      solvedUpdatedAt: json["solved_updated_at"] as String,
      user: json["user"] as String,
      category: json["category"] as int,
    );
  }
}
