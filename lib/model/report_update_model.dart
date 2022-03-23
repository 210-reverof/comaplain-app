import 'dart:convert';

class ReportUpdateModel {
  // 필드명
  final String? title;
  final String? explanation;
  final int? category;

  // 생성자
  ReportUpdateModel({
    this.title,
    this.explanation,
    this.category,
  });

  factory ReportUpdateModel.fromJson(Map<String, dynamic> json) {
    return ReportUpdateModel(
      title: json["title"] as String,
      explanation: json["explanation"] as String,
      category: json["category"] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "explanation": explanation,
      "category": category,
    };
  }

  String toJSONString() {
    Map<String, dynamic> JSON = toMap();
    String jsonSting = json.encode(JSON);

    return jsonSting;
  }
}


class SolvedReportUpdateModel {
  // 필드명
  final String? title;
  final String? explanation;
  final int? category;

  // 생성자
  SolvedReportUpdateModel({
    this.title,
    this.explanation,
    this.category,
  });

  factory SolvedReportUpdateModel.fromJson(Map<String, dynamic> json) {
    return SolvedReportUpdateModel(
      title: json["title"] as String,
      explanation: json["explanation"] as String,
      category: json["category"] as int,
    );
  }

  factory SolvedReportUpdateModel.fromModel(ReportUpdateModel model) {
    return SolvedReportUpdateModel(
      title: model.title,
      explanation: model.explanation,
      category: model.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "solved_title": title,
      "solved_explanation": explanation,
      "category": category,
    };
  }

  String toJSONString() {
    Map<String, dynamic> JSON = toMap();
    String jsonSting = json.encode(JSON);

    return jsonSting;
  }
}
