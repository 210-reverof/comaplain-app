import 'package:flutter/material.dart';
import 'package:comaplain/screen/report_writing/picture_upload_screen.dart';

class ReportWriteScreen extends StatefulWidget {
  const ReportWriteScreen({Key? key}) : super(key: key);

  @override
  _ReportWriteScreenState createState() => _ReportWriteScreenState();
}

class _ReportWriteScreenState extends State<ReportWriteScreen> {
  @override
  Widget build(BuildContext context) {
    // Back button
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
        body: PictureUploadScreen());
  }
}
