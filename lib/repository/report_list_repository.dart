import 'dart:convert';
import 'package:comaplain/model/report_list_model.dart';
import 'package:http/http.dart' as http;

class ReportListRepository {
  // Report 리스트 페이지
  listReport(String state, num x, num y) async {
    String baseUrl =
        'http://34.64.175.9/ui/${state}/?latitude=${x}&longitude=${y}';

    final response = await http.get(Uri.parse(baseUrl)); // http 데이터를 가져온다.
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      List<ReportListModel> reports = parseReportList(responseBody);

      return reports;
    } else {
      return "Error";
    }
  }

  // Report 리스트 페이지 parse
  List<ReportListModel> parseReportList(String responseBody) {
    List<dynamic> parsed = json.decode(responseBody);

    return parsed
        .map<ReportListModel>((json) => ReportListModel.fromJson(json))
        .toList();
  }

  // Report 제거
  Future<String> deleteReport(int id) async {
    print("$id : 삭제");
    http.Response res = await http.delete(
      Uri.http('34.64.175.9', 'report/$id/'),
      headers: {"Content-Type": "application/json"},
    );

    return res.body;
  }
}
