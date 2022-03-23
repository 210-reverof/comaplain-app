import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppInfoScreen extends StatefulWidget {
  const AppInfoScreen({Key? key}) : super(key: key);

  @override
  _AppInfoScreenState createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {

  @override
  Widget build(BuildContext context) {

    Widget backButton() {
      return GestureDetector(
        onTap: () {
          // 이전 페이지로 이동
          Navigator.pop(context);
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 33, 0, 0),
            child: Image.asset('assets/btn_back.png')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfffffcf7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: backButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 13),
                child: Text(
                    "App Information",
                    style: const TextStyle(
                        color:  const Color(0xff2e2e2e),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Roboto",
                        fontStyle:  FontStyle.normal,
                        fontSize: 23.3
                    ),
                    textAlign: TextAlign.center
                ),
              )
            ),
            Center(
                child: Container(
                  padding: EdgeInsets.only(top: 31.13, bottom: 15),
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/main_log.png')
                )
            ),
            _content(
                "Comaplain App shares the threats to each other, which are due "
                "to malfunctioning facilities and unsafe areas. In this way, "
                "Comaplain App contributes to making the world safer and better. "
                "Participate in it and make the world safer. Please join us."
            ),
            _title("[Report]"),
            _content(
                  "  Check the areas...\n"
                  "    - that have malfunctioning facilities.\n"
                  "    - that are unsafe areas."
            ),

            _title("[Solved Report]"),
            _content(
              "  Check the facilities and the areas becoming safer."
            ),

            _title("[My Report]"),
            _content(
              "  Check the information you have shared."
            ),
          ],
        ),
      ),
    );
  }

  Container _title(String title) {
    return Container(
            padding: EdgeInsets.only(top: 20, left: 38, right: 38),
            child: Text(
                title,
                style: const TextStyle(
                    color:  const Color(0xff707070),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                    fontStyle:  FontStyle.normal,
                    fontSize: 13.3
                ),
                textAlign: TextAlign.left
            )
    );
  }

  Container _content(String content) {
    return Container(
            padding: EdgeInsets.only(top: 5, left: 38, right: 38),
            child: Text(
                content,
                style: const TextStyle(
                    color:  const Color(0xff707070),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                    fontStyle:  FontStyle.normal,
                    fontSize: 13.3
                ),
                textAlign: TextAlign.left
            )
    );
  }
}