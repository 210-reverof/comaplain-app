import 'dart:convert';

import 'package:comaplain/model/user_model.dart';
import 'package:comaplain/screen/login/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../root_screen.dart';

final GoogleSignIn googleSignIn = new GoogleSignIn();
UserModel CURRENT_USER = UserModel();
GoogleSignInAccount? gCurrentUser;
bool isSignedIn = false;

class LogInScreen extends StatefulWidget {
  @override
  _LoginPageScreenState createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LogInScreen> {
  @override
  void initState() {
    super.initState();

    // 앱 로그 관리
    googleSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      if (gSignInAccount == null) return;

      // 등록 여부 판별
      controlSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error Message : " + gError);
    });

    googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return loginMainScreen(context);
  }

  Scaffold loginMainScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          SizedBox(height: 200),
          Image.asset(
            "assets/logo_text_white.png",
            width: 250,
            height: 250,
          ),
          loginBtn(context)
        ]),
      ),
    );
  }

  // 로그인 상태 여부에 따라 isSignedIn flag값을 변경해줌
  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      saveUserInfo();
      // setState(() {
      //   isSignedIn = true;
      // });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  saveUserInfo() async {
    // 현재 구글 계정 정보 가져오기
    final GoogleSignInAccount? gCurrentUser = googleSignIn.currentUser;
    String uidJSONString = "{\"firebase_uid\": \"" + gCurrentUser!.id + "\"}";

    http.Response res = await http.post(Uri.http('34.64.175.9', 'user/login'),
        headers: {"Content-Type": "application/json"}, body: uidJSONString);

    // 해당 유저의 db정보가 없다면
    if (res.body == "{\"content\":\"It doesn't exist.\"}") {
      // 회원가입 페이지로 이동
      setState(() {
        isSignedIn = true;
      });
      final username = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SignupScreen(
                    currGCurrentUser: gCurrentUser,
                  )));
    } else {
      setState(() {
        print(jsonDecode(res.body)['user_info']['created_at'].toString());
        CURRENT_USER = UserModel.fromJson(jsonDecode(res.body)['user_info']);
        isSignedIn = true;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RootScreen()));
    }

    return;
    // 현재 유저정보에 값 셋팅하기
  }
}

loginBtn(context) {
  return InkWell(
      onTap: () {
        loginUser();
      },
      child:
          Image.asset("assets/btn_login.png", width: 600 / 3, height: 120 / 3));
}

loginUser() {
  googleSignIn.signIn();
}

logoutUser() {
  googleSignIn.signOut();
}
