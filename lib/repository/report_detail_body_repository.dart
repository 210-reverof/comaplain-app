import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/report_detail_body_model.dart';

class ReportDetailBodyRepository {
  // Report Detail
  detailReport(int id) async {
    String baseUrl = 'http://34.64.175.9/report/$id/';

    final response = await http.get(Uri.parse(baseUrl)); // http 데이터를 가져온다.

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      var parsed = json.decode(responseBody);
      ReportDetailBodyModel reports = ReportDetailBodyModel.fromJson(parsed);

      return reports;
    } else {
      return "Error";
    }
  }
}
