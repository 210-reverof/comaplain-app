import 'dart:convert';

import 'package:comaplain/model/comments_create_model.dart';
import 'package:comaplain/model/comments_list_model.dart';
import 'package:http/http.dart' as http;

class ReportDetailCommentRepository {
  // Report ID 모든 댓글 조회
  listComments(int id) async {
    String baseUrl = 'http://34.64.175.9/report/$id/comments/';

    final response = await http.get(Uri.parse(baseUrl)); // http 데이터를 가져온다.

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      List<CommentsListModel> reports = parseComments(responseBody);

      return reports;
    } else {
      return "Error";
    }
  }

  // Report ID 모든 댓글 parse
  List<CommentsListModel> parseComments(String responseBody) {
    List<dynamic> parsed = json.decode(responseBody);

    return parsed
        .map<CommentsListModel>((json) => CommentsListModel.fromJson(json))
        .toList();
  }

  /// ********************** Report 댓글 생성, 삭제 *****************************/

  // Report 댓글 생성
  Future<String> createComments(CommentsCreateModel commentsCreateModel) async {
    var body = commentsCreateModel.toCommentCreateJSONString();

    http.Response res = await http.post(
        Uri.http('34.64.175.9', 'report/comment/'),
        headers: {"Content-Type": "application/json"},
        body: body);

    return res.body;
  }

  // Report 댓글 제거
  Future<String> deleteComments(int id) async {
    http.Response res = await http.delete(
      Uri.http('34.64.175.9', 'report/comment/$id/'),
      headers: {"Content-Type": "application/json"},
    );

    return res.body;
  }
}
