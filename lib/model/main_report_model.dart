class MainReportModel {
  // 필드명
  final int? id;
  final String? title;
  final String? explanation;
  final double? latitude;
  final double? longitude;
  final int? recommendation;
  final bool? solved;
  final String? createdAt;
  final String? updatedAt;
  final String? user;
  final int? category;

  // 생성자
  MainReportModel({
    this.id,
    this.title,
    this.explanation,
    this.latitude,
    this.longitude,
    this.recommendation,
    this.solved,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.category,
  });

  factory MainReportModel.fromJson(Map<String, dynamic> json) {
    return MainReportModel(
      id: json["id"],
      title: json["title"],
      explanation: json["explanation"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      recommendation: json["recommendation"],
      solved: json["solved"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      user: json["user"],
      category: json["category"],
    );
  }
}
