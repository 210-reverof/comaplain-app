class ReportDetailImageModel {
  // 필드명
  final int? id;
  final String? image;
  final int? report;

  // 생성자
  ReportDetailImageModel({
    this.id,
    this.image,
    this.report,
  });

  factory ReportDetailImageModel.fromJson(Map<String, dynamic> json) {
    return ReportDetailImageModel(
      id: json["id"] as int,
      image: json["image"] as String,
      report: json["report"] as int,
    );
  }
}
