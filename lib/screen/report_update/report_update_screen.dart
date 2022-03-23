import 'package:comaplain/model/report_update_model.dart';
import 'package:flutter/material.dart';
import 'package:comaplain/screen/report_update/update_upload_screen.dart';

class ReportUpdateScreen extends StatefulWidget {
  late int id;
  late int solved;
  late ReportUpdateModel item;

  ReportUpdateScreen(this.id, this.solved, this.item);

  @override
  _ReportUpdateScreenState createState() => _ReportUpdateScreenState();
}

class _ReportUpdateScreenState extends State<ReportUpdateScreen> {
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
        body: UpdateUploadScreen(widget.id, widget.solved, widget.item));
  }
}
