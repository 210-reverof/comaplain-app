import 'package:comaplain/model/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// listUser : userList
// hasUser : id에 맞는 user
// addUser - user 추가

class UserRepository {

  Future<String> hasUser(String uid) async {
    // API : 'http://34.64.175.9/user/login';
    String uidJSONString = "{\"firebase_uid\": \""+ uid +"\"}";

    http.Response res = await http.post(Uri.http('34.64.175.9', 'user/login'),
        headers: {"Content-Type": "application/json"}, body: uidJSONString);
    //print(res.statusCode);
    //print(res.body);

    return res.body;
  }

  Future<String> addUser(UserModel user) async {
    // API : 'http://34.64.175.9/user/join';
    var body = user.toUserJSONString();

    http.Response res = await http.post(Uri.http('34.64.175.9', 'user/join'),
        headers: {"Content-Type": "application/json"}, body: body);
    //print(res.statusCode);

    return res.body;
  }
}
