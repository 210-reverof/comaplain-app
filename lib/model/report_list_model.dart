class ReportListModel {
  // 필드명
  final int? id;
  final String? title;
  final String? explanation;
  final String? solvedTitle;
  final String? solvedExplanation;
  final int? categoryId;
  final String? content;
  final String? image;
  final String? userId;
  final num? latitude;
  final num? longitude;
  final int? recommendation;
  final int? solved;
  final String? appName;
  final String? googleProfileImage;
  final String? solvedUser;
  final String? solvedGoogleProfileImage;
  final String? solvedAppName;
  final String? createdAt;
  final String? updatedAt;
  final String? solvedCreatedAt;
  final String? solvedUpdatedAt;

  // 생성자
  ReportListModel(
      {this.id,
      this.title,
      this.explanation,
      this.solvedTitle,
      this.solvedExplanation,
      this.categoryId,
      this.content,
      this.image,
      this.userId,
      this.latitude,
      this.longitude,
      this.recommendation,
      this.solved,
      this.appName,
      this.googleProfileImage,
      this.solvedUser,
      this.solvedGoogleProfileImage,
      this.solvedAppName,
      this.createdAt,
      this.updatedAt,
      this.solvedCreatedAt,
      this.solvedUpdatedAt});

  factory ReportListModel.fromJson(Map<String, dynamic> json) {
    return ReportListModel(
      id: json["id"] as int,
      title: json["title"] as String,
      explanation: json["explanation"] as String,
      solvedTitle: json["solved_title"] as String,
      solvedExplanation: json["solved_explanation"] as String,
      categoryId: json["category_id"] as int,
      content: json["content"] as String,
      image: json["image"] as String,
      userId: json["user_id"] as String,
      latitude: json["latitude"] as num,
      longitude: json["longitude"] as num,
      recommendation: json["recommendation"] as int,
      solved: json["solved"] as int,
      appName: json["app_name"] as String,
      googleProfileImage: json["google_profile_image"] as String,
      solvedUser: json["solved_user"] as String,
      solvedGoogleProfileImage: json["solved_google_profile_image"] as String,
      solvedAppName: json["solved_app_name"] as String,
      createdAt: json["created_at"] as String,
      updatedAt: json["updated_at"] as String,
      solvedCreatedAt: json["solved_created_at"] as String,
      solvedUpdatedAt: json["solved_updated_at"] as String,
    );
  }
}
