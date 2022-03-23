import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/report_detail_image_model.dart';

class ReportDetailImageRepository {
  // Report ID 모든 이미지 조회
  detailImageReport(int id, String solved) async {
    String baseUrl = 'http://34.64.175.9/report/${id}/${solved}images/';

    final response = await http.get(Uri.parse(baseUrl)); // http 데이터를 가져온다.
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<ReportDetailImageModel> reports = parseReport(responseBody);

      return reports;
    } else {
      return "Error";
    }
  }
 // Report ID 모든 이미지 조회 parse
  List<ReportDetailImageModel> parseReport(String responseBody) {
    List<dynamic> parsed = json.decode(responseBody);

    return parsed
        .map<ReportDetailImageModel>(
            (json) => ReportDetailImageModel.fromJson(json))
        .toList();
  }
}
