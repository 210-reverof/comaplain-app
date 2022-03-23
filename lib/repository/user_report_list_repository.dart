import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_report_list_model.dart';

class UserReportListRepository {
  // User Report 리스트 페이지
  listReportUser(String uid) async {
    String baseUrl =
        'http://34.64.175.9/ui/my_report_list/?uid=$uid';

    final response = await http.get(Uri.parse(baseUrl)); // http 데이터를 가져온다.
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      List<UserReportListModel> reports = parseReportList(responseBody);

      return reports;
    } else {
      return "Error";
    }
  }

  // User Report 리스트 페이지 parse
  List<UserReportListModel> parseReportList(String responseBody) {
    List<dynamic> parsed = json.decode(responseBody);

    return parsed
        .map<UserReportListModel>((json) => UserReportListModel.fromJson(json))
        .toList();
  }


}
