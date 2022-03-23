import 'package:comaplain/screen/app_info/app_info_screen.dart';
import 'package:comaplain/screen/my_page/report_count_screen.dart';
import 'package:comaplain/screen/my_page/settings/settings_screen.dart';
import 'package:comaplain/screen/my_page/user_report_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:comaplain/screen/login/login_screen.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfffffcf7), body: _buildBody());
  }

  setter() {
    setState(() {
    });
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: [
          Center(
              child: Container(
            padding: EdgeInsets.only(top: 80),
            child: Text("My Page",
                style: const TextStyle(
                    color: const Color(0xff2e2e2e),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 23.3),
                textAlign: TextAlign.center),
          )),

          SizedBox(
            height: 30.0,
          ),

          // 프로필
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                // 이미지
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage:
                      NetworkImage(CURRENT_USER.googleProfileImage.toString()),
                ),

                SizedBox(
                  width: 15.0,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.ltr,
                  children: [
                    // 닉네임
                    Text(
                      CURRENT_USER.appName.toString(),
                      style: TextStyle(fontSize: 16),
                    ),

                    SizedBox(
                      height: 5.0,
                    ),

                    // 신고 글 개수
                    ReportCountScreen(CURRENT_USER.firebaseUID.toString()),
                  ],
                )
              ],
            ),
          ),

          SizedBox(
            height: 20.0,
          ),

          // my report
          InkWell(
            onTap: () {
              // UserReportListScreen 이동
              Navigator.pushNamed(context, '/UserReportListScreen',
                  arguments: UserReportListArguments(
                      uid: CURRENT_USER.firebaseUID.toString(),
                      appName: CURRENT_USER.appName.toString(),
                      googleProfileImage:
                          CURRENT_USER.googleProfileImage.toString()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 30.0,
              child: Padding(
                padding: EdgeInsets.only(left: 30.0, top: 5.0),
                child: Text("my report",
                    style: const TextStyle(
                        color: const Color(0xff686868),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 16),
                    textAlign: TextAlign.left),
              ),
            ),
          ),
          // 구분선
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(
              thickness: 1,
            ),
          ),

          // settings
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(setter)));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 30.0,
              child: Padding(
                padding: EdgeInsets.only(left: 30.0, top: 5.0),
                child: Text("settings",
                    style: const TextStyle(
                        color: const Color(0xff686868),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 16),
                    textAlign: TextAlign.left),
              ),
            ),
          ),
          // 구분선
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(
              thickness: 1,
            ),
          ),

          // app information"
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AppInfoScreen()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 30.0,
              child: Padding(
                padding: EdgeInsets.only(left: 30.0, top: 5.0),
                child: Text("app information",
                    style: const TextStyle(
                        color: const Color(0xff686868),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 16),
                    textAlign: TextAlign.left),
              ),
            ),
          ),
          // 구분선
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(
              thickness: 1,
            ),
          ),

          // log out
          InkWell(
            onTap: () {
              logoutUser();

              // 지금까지 모든 페이지를 스택에서 삭제하고 RootScreen으로 이동
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 30.0,
              child: Padding(
                padding: EdgeInsets.only(left: 30.0, top: 5.0),
                child: Text("log out",
                    style: const TextStyle(
                        color: const Color(0xff686868),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 16),
                    textAlign: TextAlign.left),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
