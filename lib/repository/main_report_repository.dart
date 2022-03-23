import 'dart:convert';
import 'package:comaplain/model/main_report_model.dart';
import 'package:http/http.dart' as http;

class MainReportRepository {
  mainReportList(double lat, double lng) async {
    String url = "http://34.64.175.9/ui/main/?latitude=" +
        lat.toString() +
        "&longitude=" +
        lng.toString();

    http.Response res = await http.get(Uri.parse(url));

    String resBody = utf8.decode(res.bodyBytes);
    List<dynamic> resBodyArray = json.decode(resBody);
    List<MainReportModel> mainReportArray = [];

    for(int i = 0; i<resBodyArray.length;i++) {
      mainReportArray.add(MainReportModel.fromJson(resBodyArray[i]));
    }

    return mainReportArray;
  }
}
