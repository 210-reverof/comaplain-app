import 'package:comaplain/screen/solve_writing/solve_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:comaplain/screen/report_writing/picture_upload_screen.dart';

class SolveWriteScreen extends StatefulWidget {
  final int id;
  final int category;
  SolveWriteScreen(this.id, this.category);

  @override
  _SolveWriteScreenState createState() => _SolveWriteScreenState();
}

class _SolveWriteScreenState extends State<SolveWriteScreen> {
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
        body: SolveUploadScreen(widget.id, widget.category));
  }
}
