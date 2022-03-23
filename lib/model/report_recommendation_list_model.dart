class ReportRecommendationListModel {
  // 필드명
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? user;
  final int? report;

  // 생성자
  ReportRecommendationListModel(
      {this.id, this.createdAt, this.updatedAt, this.user, this.report});

  factory ReportRecommendationListModel.fromJson(Map<String, dynamic> json) {
    return ReportRecommendationListModel(
      id: json["id"] as int,
      createdAt: json["created_at"] as String,
      updatedAt: json["updated_at"] as String,
      user: json["user"] as String,
      report: json["report"] as int,
    );
  }
}
