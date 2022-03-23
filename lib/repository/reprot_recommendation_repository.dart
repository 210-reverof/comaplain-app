import '../model/report_recommendation_create_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/report_recommendation_list_model.dart';

class ReportRecommendationRepository {
  // Report Recommendation GET
  listRecommendation() async {
    String baseUrl = 'http://34.64.175.9/report/recommendation/';

    final response = await http.get(Uri.parse(baseUrl)); // http 데이터를 가져온다.
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      List<ReportRecommendationListModel> reports =
          parseReportRecommendation(responseBody);

      return reports;
    } else {
      return "Error";
    }
  }

  // Report Recommendation GET parse
  List<ReportRecommendationListModel> parseReportRecommendation(
      String responseBody) {
    List<dynamic> parsed = json.decode(responseBody);

    return parsed
        .map<ReportRecommendationListModel>(
            (json) => ReportRecommendationListModel.fromJson(json))
        .toList();
  }

  // Report Recommendation create
  Future<String> createRecommendation(
      ReportRecommendationCreateModel reportRecommendationCreateModel) async {
    var body = reportRecommendationCreateModel
        .toReportRecommendationCreateJSONString();

    http.Response res = await http.post(
        Uri.http('34.64.175.9', 'report/recommendation/'),
        headers: {"Content-Type": "application/json"},
        body: body);

    return res.body;
  }
}
