import 'dart:convert';
import 'package:comaplain/model/report_get_model.dart';
import 'package:http/http.dart' as http;

class ReportGetRepository {
  // Report GET 
  getReport() async {
    String baseUrl = 'http://34.64.175.9/report/';

    final response = await http.get(Uri.parse(baseUrl)); // http 데이터를 가져온다.
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      List<ReportGetModel> reports = parseReportList(responseBody);

      return reports;
    } else {
      return "Error";
    }
  }

  // Report GET parse
  List<ReportGetModel> parseReportList(String responseBody) {
    List<dynamic> parsed = json.decode(responseBody);

    return parsed
        .map<ReportGetModel>((json) => ReportGetModel.fromJson(json))
        .toList();
  }


}
