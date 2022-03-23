import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../model/solve_write_model.dart';

class SolveWriteRepository {
  Future<String> createSolveText(
      SolveWriteModel solveWriteModel, List<XFile> pickedImgs, int id) async {
    var body = solveWriteModel.toJSONString();

    http.Response response = await http.patch(
        Uri.parse('http://34.64.175.9/report/$id/'),
        headers: {"Content-Type": "application/json"},
        body: body);

    var reportTextJSON = json.decode(response.body.toString());

    // 이미지 넣기
    for (int i = 0; i < pickedImgs.length; i++) {
      int currId = reportTextJSON['id'];
      await createSolveImage(currId, pickedImgs[i]);
    }

    return response.body;
  }

  // Report 이미지 Post
  createSolveImage(int reportId, XFile file) async {
    var path = file.path;

    String addimageUrl = 'http://34.64.175.9/report/images/solved_upload/';

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };

    Map<String, String> body = {"report": "$reportId"};

    // String filepath = "assets/test.png"; < 성공한경로

    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', path));

    var response = await request.send();

    if (response.statusCode == 201) {
      // 이미지 등록 성공
      return response.statusCode;
    } else {
      // report 가 없는 경우 발생 > 400 코드!
      return response.statusCode;
    }
  }
}
