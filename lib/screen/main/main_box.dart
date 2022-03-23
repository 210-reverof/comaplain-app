import 'dart:math';

import 'package:comaplain/screen/main/main_screen.dart';
import 'package:comaplain/screen/report_detail/report_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:comaplain/model/main_report_model.dart';

class MainBox extends StatefulWidget {
  MainBox({required this.reportList});
  List<MainReportModel> reportList;

  @override
  MainBoxState createState() => MainBoxState();
}

class MainBoxState extends State<MainBox> {
  MainReportModel selectedReport = MainReportModel();
  List<double> centerPos = [150, 150];

  List<Point> inLinePos = [
    Point(x:150, y:100), // 0
    Point(x:193, y:125), // 1
    Point(x:193, y:175), // 2
    Point(x:150, y:200), // 3
    Point(x:107, y:125), // 4
    Point(x:107, y:175), // 5
  ];
  List<Point> outLinePos = [
    Point(x:200, y:64), // 6
    Point(x:250, y:150), // 7
    Point(x:200, y:236), // 8
    Point(x:100, y:236), // 9
    Point(x:50, y:150), // 10
    Point(x:100, y:64), // 11
  ];


  List<int> imagenNum = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3];

  @override
  void initState() {
    super.initState();

    // 선 추가하기
    inLinePos[0].line = getLineImage(130, 110, 40, 40, "0");
    inLinePos[1].line = getLineImage(150, 120, 30, 30, "1");
    inLinePos[2].line = getLineImage(150, 150, 30, 30, "2");
    inLinePos[3].line = getLineImage(130, 150, 40, 40, "0");
    inLinePos[4].line = getLineImage(125, 125, 30, 30, "5");
    inLinePos[5].line = getLineImage(125, 145, 30, 30, "4");

    outLinePos[0].line = getLineImage(150, 70, 80, 80, "6");
    outLinePos[1].line = getLineImage(160, 110, 80, 80, "7");
    outLinePos[2].line = getLineImage(150, 150, 80, 80, "8");
    outLinePos[3].line = getLineImage(103, 150, 80, 80, "6");
    outLinePos[4].line = getLineImage(65, 110, 80, 80, "7");
    outLinePos[5].line = getLineImage(70, 70, 80, 80, "11");

    inLinePos.shuffle();
    outLinePos.shuffle();
    imagenNum.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return getMainBox(widget.reportList);
  }

  // 시각화 부분
  Container getMainBox(List<MainReportModel> reportList) {
    List<Widget> stackList = [
      // 베이스 박스
      Positioned(
        child: Container(
        width: 300,
        height: 300,
        color: Color.fromARGB(255, 255, 255, 255),
        child : Image.asset("assets/main_box/main_background.png"),
      )),

      Positioned(
          left: 66,
          top: 15,
          child: Container(
            child: Text(
              "Tap Hot Reports Around Me",
              style: TextStyle(
                  color: Color.fromARGB(255, 145, 145, 145),
                  fontWeight: FontWeight.normal,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 14),
            ),
          )),

      // 아래 박스
      getUnderBox(selectedReport)
    ];

    for (int i = 0; i < reportList.length; i++) {
      stackList.add(getPositionedImage(i, reportList[i])[1]);
    }


    for (int i = 0; i < reportList.length; i++) {
      stackList.add(getPositionedImage(i, reportList[i])[0]);
    }

    // 가운데 정점
    stackList.add(
      Positioned(
        left: centerPos[0] - 23,
        top: centerPos[1] - 23,
        child: Image.asset("assets/main_box/my_point.png"), width:46, height:46)
    );

    return Container(
        color: Colors.white,
        width: 300,
        height: 300,
        child: Stack(children: stackList));
  }

   Positioned getLineImage(double left, double top, double width, double height, String imgName) {
     return Positioned(
        left: left,
        top: top,
        child: Image.asset("assets/main_box/line/line_$imgName.png"), width:width, height:height);
   }

  List<Positioned> getPositionedImage(int posNum, MainReportModel currReport) {
    List<Positioned> resultList = [];
    int patternNum = imagenNum[posNum];
    String imageDir = "";

    // broken report
    if (currReport.category == 1) {
      imageDir = "assets/main_box/blue_" + patternNum.toString() + ".png";
    }
    // safety report
    else if (currReport.category == 2) {
      imageDir = "assets/main_box/yellow_" + patternNum.toString() + ".png";
    }
    // etc report
    else {
      imageDir = "assets/main_box/purple_" + patternNum.toString() + ".png";
    }

    double x = 0.0;
    double y = 0.0;
    Positioned line;

    if (posNum < 6) {
      x = inLinePos[posNum].x.toDouble();
      y = inLinePos[posNum].y.toDouble();
      line = inLinePos[posNum].line as Positioned;
    } else {
      x = outLinePos[posNum - 6].x.toDouble();
      y = outLinePos[posNum - 6].y.toDouble();
      line = outLinePos[posNum - 6].line as Positioned;
    }

    double ballSize = posNum < 6 ? 50 : 40;

    resultList.add(Positioned(
      left: x - (ballSize / 2),
      top: y - (ballSize / 2),
      child: InkWell(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.asset(
              imageDir,
              width: ballSize,
              height: ballSize,
            ),
            Text( currReport.title.toString().length < 3 ? currReport.title.toString() :
              currReport.title.toString().substring(0, 3),
              style: TextStyle(
                  color: Color.fromARGB(255, 241, 241, 241),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 14),
            )
          ],
        ),
        onTap: () {
          setState(() {
            selectedReport = currReport;
          });
        },
      ),
    ));

    resultList.add(line);

    return resultList;
  }

  Positioned getUnderBox(MainReportModel selectReport) {
    if (selectReport.title.toString() == "null") {
      return Positioned(
        child: Container(),
      );
    } else {
      String moveBtnDir = selectReport.category == 1
          ? 'assets/main_box/btn_move_1.png'
          : selectReport.category == 2
              ? 'assets/main_box/btn_move_2.png'
              : 'assets/main_box/btn_move_3.png';
      return Positioned(
          left: 120,
          top: 270,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/ReportDetailScreen',
                  arguments: ReportDetilArguments(
                      id: selectedReport.id as int, listUpdate: listUpdate));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: 180,
                height: 30,
                color: Color.fromARGB(49, 71, 71, 71),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text( selectedReport.title!.length < 23 ?
                        selectedReport.title.toString() : selectedReport.title.toString().substring(0, 23),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Image.asset(
                        moveBtnDir,
                        width: 20,
                        height: 20,
                      ),
                    )
                  ],
                )),
              ),
            ),
          ));
    }
  }

  listUpdate() {
    setState(() {});
  }
}

class Point {
  double x = 0;
  double y = 0;
  Positioned? line;

  Point({required this.x, required this.y, this.line});
}