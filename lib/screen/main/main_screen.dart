import 'dart:convert';
import 'package:comaplain/bloc/main_report/main_report_cubit.dart';
import 'package:comaplain/bloc/main_report/main_report_state.dart';
import 'package:comaplain/model/main_report_model.dart';
import 'package:comaplain/repository/main_report_repository.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:comaplain/screen/login/login_screen.dart';
import 'package:comaplain/screen/main/main_box.dart';
import 'package:comaplain/screen/report_detail/report_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:comaplain/screen/report_writing/report_write_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MainReportCubit>(context).mainReportList(
        CURRENT_USER.latitude as double, CURRENT_USER.longitude as double);
    print(CURRENT_USER.latitude.toString() + " " + CURRENT_USER.longitude.toString());

    return Scaffold(
      body: BlocBuilder<MainReportCubit, MainReportState>(
        builder: (context, state) {
          if (state is Loaded) {
            List<MainReportModel> mainReports =
                List.from(state.mainReports.reversed);
            List<MainReportModel> reportsOfCategoryIndex1 = [];
            List<MainReportModel> reportsOfCategoryIndex2 = [];
            List<MainReportModel> reportsOfCategoryIndex3 = [];

            // 카테고리별로 구분
            for (int i = 0; i < mainReports.length; i++) {
              int currReportCategory = mainReports[i].category as int;
              switch (currReportCategory) {
                case 1:
                  reportsOfCategoryIndex1.add(mainReports[i]);
                  break;
                case 2:
                  reportsOfCategoryIndex2.add(mainReports[i]);
                  break;
                case 3:
                  reportsOfCategoryIndex3.add(mainReports[i]);
                  break;
              }
            }

            return Container(
              color: Color(0xfffffcf7),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    child: Image.asset('assets/logo_text_single.png'),
                    height: 120,
                  ),
                  Container(width:300, height:300, child: MainBox(reportList:mainReports)),
                  SizedBox(height: 10),
                  getMainListView(mainReports, reportsOfCategoryIndex1,
                      reportsOfCategoryIndex2, reportsOfCategoryIndex3)
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  // 아래 가로 리스트뷰 집합
  getMainListView(List<MainReportModel> reports, List<MainReportModel> list1,
      List<MainReportModel> list2, List<MainReportModel> list3) {
        print(MediaQuery.of(context).size.height - 500);
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 550,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return getEachListView(index, reports, list1, list2, list3);
          },
          itemCount: 4,
          viewportFraction: 0.9,
          scale: 0.95,
          loop: false,
        ));
  }

  // 가로 항목들 중 하나
  getEachListView(
      int index,
      List<MainReportModel> reports,
      List<MainReportModel> list1,
      List<MainReportModel> list2,
      List<MainReportModel> list3) {
    // 통합 리스트
    if (index == 0) {
      if (reports.length == 0) return getEmptyTile();
      return Container(
          color: Color(0x00ffffff),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: reports.length,
            itemBuilder: (BuildContext context, int i) {
              return getEachListTile(reports[i]);
            },
          ));
    }

    // broken
    else if (index == 1) {
      if (list1.length == 0) return getEmptyTile();
      return Container(
          color: Color(0x00ffffff),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: list1.length,
            itemBuilder: (BuildContext context, int i) {
              return getEachListTile(list1[i]);
            },
          ));
    } else if (index == 2) {
      if (list2.length == 0) return getEmptyTile();
      return Container(
          color: Color(0x00ffffff),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: list2.length,
            itemBuilder: (BuildContext context, int i) {
              return getEachListTile(list2[i]);
            },
          ));
    } else if (index == 3) {
      if (list3.length == 0) return getEmptyTile();
      return Container(
          color: Color(0x00ffffff),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: list3.length,
            itemBuilder: (BuildContext context, int i) {
              return getEachListTile(list3[i]);
            },
          ));
    }
  }

  getEmptyTile() {
    return Container(
        margin: EdgeInsets.all(3),
        width: 320,
        height: 40,
        child: Center(
          child: Text("No Reprots related with this category",
              style: const TextStyle(
                  color: Color.fromARGB(255, 122, 122, 122),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x59000000),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 0)
            ],
            color: Color(0xffffffff)));
  }

  // 리스트 뷰 내 타일
  getEachListTile(MainReportModel currReport) {
    int stringLength = currReport.category as int == 1? 33 : currReport.category as int == 2? 25 : 37;
    String tmpItemInfo = currReport.title!.length < stringLength ? currReport.title.toString() : currReport.title.toString().substring(0,stringLength);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/ReportDetailScreen',
              arguments: ReportDetilArguments(id: currReport.id as int, listUpdate: listUpdate));
      },
      child: Container(
          child: Center(
              child: Row(children: [
            SizedBox(width: 8),
    
            // 카테고리 상자
            getCategoryBox(currReport.category as int),
    
            SizedBox(width: 8),
    
            Text(tmpItemInfo),
          ])),
          margin: EdgeInsets.all(3),
          width: 300,
          height: 40,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x59000000),
                    offset: Offset(0, 0),
                    blurRadius: 5,
                    spreadRadius: 0)
              ],
              color: Color(0xffffffff))),
    );
  }

  // 카테고리 단일 박스
  Container getCategoryBox(int categoryNum) {
    String CategoryName = "";
    double boxWidth = 0;
    if (categoryNum == 1) {
      CategoryName = "broken";
      boxWidth = 60;
    } else if (categoryNum == 2) {
      CategoryName = "security";
      boxWidth = 100;
    } else {
      CategoryName = "etc";
      boxWidth = 40;
    }

    return Container(
      height: 25,
      width: boxWidth,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                "assets/category_" + CategoryName + ".png",
                fit: BoxFit.fill,
                height: 25,
                width: boxWidth,
              )),
          Text(categoryNum == 2 ? "public safety" : CategoryName,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        ],
      ),
    );
  }

  // 신고 버튼
  getReportButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0), //가로폭이 줄어듦
      child: InkWell(
        onTap: () {
          // 신고 화면으로 이동
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ReportWriteScreen()));
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
                      ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/btn_report.png',
                fit: BoxFit.fill,
                height: 40,
                width: 300,
              )),
            Text(
              "REPORT",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: const Color(0xfff8f8f8),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
    listUpdate() {
    setState(() {});
  }
}