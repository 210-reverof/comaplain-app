import 'package:comaplain/bloc/report_write/report_write_cubit.dart';
import 'package:comaplain/bloc/report_write/report_write_state.dart';
import 'package:comaplain/model/report_write_model.dart';
import 'package:comaplain/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:comaplain/screen/report_list/report_list_screen.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

//ReportWritingScreen
class PictureUploadScreen extends StatefulWidget {
  @override
  _PictureUploadScreenState createState() => _PictureUploadScreenState();
}

class _PictureUploadScreenState extends State<PictureUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
  List<bool> categoryPicked = [true, false, false];
  String currReportTitle = "";
  String currReportExplanation = "";
  bool locationPermission = false;

  Future<void> _pickImg() async {
    final XFile? selectedImages =
        await _picker.pickImage(source: ImageSource.camera);
    if (selectedImages != null) {
      _pickedImgs.add(selectedImages);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPermission().then((value) {
      if (value) {
        setState(() {
          locationPermission = true;
        });
      } else {
        setState(() {
          locationPermission = false;
        });
      }
    });
  }

  bool broken = false;
  bool public_safety = false;
  bool etc = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 65),
              child: Text("Report",
                  style: const TextStyle(
                      color: const Color(0xff2e2e2e),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 70.0 / 3),
                  textAlign: TextAlign.left),
            ),
          ),

          Divider(
              height: MediaQuery.of(context).size.height / 50,
              color: const Color(0xfffffcf7)),
          // picture uploader
          getImageUploader(),

          Divider(
              height: MediaQuery.of(context).size.height / 60,
              color: const Color(0xfffffcf7)),
          getCategoryToggle(),

          Divider(
              height: MediaQuery.of(context).size.height / 50,
              color: const Color(0xfffffcf7)),
          getLabel("Title"),

          Padding(
            padding: EdgeInsets.fromLTRB(30, 7, 30, 7),
            child: Container(
              padding: EdgeInsets.fromLTRB(18, 14, 15, 7),
              height: MediaQuery.of(context).size.height / 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                color: const Color(0xffffffff),
                border: Border.all(color: const Color(0xffdbdbdb), width: 1.3),
              ),
              child: TextField(
                cursorColor: const Color(0xff191919),
                decoration: InputDecoration.collapsed(hintText: ""),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                onChanged: (val) {
                  setState(() {
                    currReportTitle = val;
                  });
                },
              ),
            ),
          ),

          Divider(
              height: MediaQuery.of(context).size.height / 80,
              color: const Color(0xfffffcf7)),
          getLabel("Explanation"),

          Padding(
            padding: EdgeInsets.fromLTRB(30, 7, 30, 7),
            child: Container(
              height: MediaQuery.of(context).size.height / 4.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                color: const Color(0xffffffff),
                border: Border.all(color: const Color(0xffdbdbdb), width: 1.3),
              ),
              padding: EdgeInsets.fromLTRB(18, 15, 15, 7),
              child: TextField(
                cursorColor: const Color(0xff191919),
                decoration: InputDecoration.collapsed(hintText: ""),
                maxLines: 6,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                onChanged: (val) {
                  setState(() {
                    currReportExplanation = val;
                    print(currReportExplanation);
                  });
                },
              ),
            ),
          ),

          Divider(
              height: MediaQuery.of(context).size.height / 120,
              color: const Color(0xfffffcf7)),
          getRegisterButton(),
          getCancelButton(),
        ],
      ),
    );
  }

  Container getLabel(String str) {
    return Container(
      padding: EdgeInsets.only(left: 30),
      child: Text(str,
          style: const TextStyle(
              color: const Color(0xff191919),
              fontWeight: FontWeight.w500,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: 20),
          textAlign: TextAlign.left),
    );
  }

  Row getCategoryToggle() {
    return Row(children: <Widget>[
      SizedBox(
        width: 18,
      ),
      getCategoryBox(95, 0, 'broken', 'assets/category_broken.png'),
      getCategoryBox(142, 1, 'public safety', 'assets/category_security.png'),
      getCategoryBox(58, 2, 'etc', 'assets/category_etc.png'),
    ]);
  }

  GestureDetector getCategoryBox(
      double width, int categoryNum, String categoryName, String imgDir) {
    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                  width: width, //58
                  height: MediaQuery.of(context).size.height / 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            spreadRadius: 0)
                      ],
                      color: const Color(0xffeeeeee)),
                  child: Center(
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                          color: const Color(0xff9ba4a1),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ))),
          AnimatedOpacity(
            opacity: categoryPicked[categoryNum] ? 1.0 : 0.0, // 2
            duration: Duration(milliseconds: 100),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    width: width, //58
                    height: MediaQuery.of(context).size.height / 20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              AssetImage(imgDir)), //'assets/category_etc.png'
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    categoryName,
                    style: const TextStyle(
                        color: const Color(0xffededed),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          for (int i = 0; i < 3; i++) {
            categoryPicked[i] = false;
          }
          categoryPicked[categoryNum] = true;
        });
      },
    );
  }

  Row getImageUploader() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 25),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.height / 9,
                height: MediaQuery.of(context).size.height / 9,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.height / 9,
                      height: MediaQuery.of(context).size.height / 9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.5)),
                          border: Border.all(
                              color: const Color(0xffdbdbdb), width: 1.5),
                          color: const Color(0xffffffff)),
                    ),
                    GestureDetector(
                      child: Center(
                          child:
                              Image.asset('assets/btn_photo.png', width: 42.7)),
                      onTap: () {
                        _pickImg();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 25),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(5, (int index) {
                return Container(
                  margin: const EdgeInsets.only(left: 9),
                  width: MediaQuery.of(context).size.height / 9,
                  height: MediaQuery.of(context).size.height / 9,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          decoration: index <= _pickedImgs.length - 1
                              ? BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                          File(_pickedImgs[index].path))),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.5)),
                                  border: Border.all(
                                      color: const Color(0xffdbdbdb),
                                      width: 1.5),
                                  color: const Color(0xffffffff))
                              : BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.5)),
                                  border: Border.all(
                                      color: const Color(0xffdbdbdb),
                                      width: 1.5),
                                  color: const Color(0xffffffff)),
                          child: index <= _pickedImgs.length - 1
                              ? null
                              : Center(
                                  child: const Text(
                                  'No image selected.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ))),
                    ],
                  ),
                );
              })),
            ),
          ),
        ),
      ],
    );
  }

  getRegisterButton() {
    return Center(
      child: FutureBuilder<Pos>(
        future: getCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return LoadedRegister(
                snapshot.data.latitude, snapshot.data.longitude);
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }

  GestureDetector LoadedRegister(double realLat, double realLng) {
    return GestureDetector(
      child: Center(
        child: Container(
          width: 230,
          height: MediaQuery.of(context).size.height / 15,
          padding: EdgeInsets.all(12.0),
          child: Text(
            "register",
            style: const TextStyle(
                color: const Color(0xffededed),
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
                fontSize: 18),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: const Color(0xffededed), width: 1),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 2),
                    blurRadius: 3,
                    spreadRadius: 0)
              ],
              color: const Color(0xff05bc71)),
        ),
      ),
      onTap: () async {
        // 필수 입력 항목을 작성해야 한다는 msg를 보냄.
        String errorMsg = "";

        if (_pickedImgs.length == 0) {
          errorMsg = "사진은 필수 입력 항목입니다.";
        } else if (currReportTitle == "") {
          errorMsg = "제목은 필수 입력 항목입니다.";
        } else if (currReportExplanation == "") {
          errorMsg = "내용은 필수 입력 항목입니다.";
        }
        // 필수 입력 항목을 모두 작성했다면 getImage() 실행
        if (errorMsg == "") {
          ReportWriteModel currReport = ReportWriteModel(
              title: currReportTitle,
              explanation: currReportExplanation,
              latitude: realLat,
              longitude: realLng,
              recommendation: 0,
              solved: 0,
              user: CURRENT_USER.firebaseUID,
              solvedUser: CURRENT_USER.firebaseUID,
              category: categoryPicked[0]
                  ? 1
                  : categoryPicked[1]
                      ? 2
                      : 3);
          BlocProvider.of<ReportWriteCubit>(context)
              .createReportText(currReport, _pickedImgs);

          // 메서드를 sync 메서드로 변경했기 때문에 sleep으로 대체
          sleep(Duration(milliseconds: 100));
          //await Future.delayed(Duration(milliseconds: 100));

          Navigator.pushNamedAndRemoveUntil(
              context, '/RootScreen', (_) => false);

          // 필수 입력 항목을 작성하지 않았다면 dialog 실행
        } else {
          showMsgDialog(errorMsg);
        }
      },
    );
  }

  Future<Pos> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return new Pos(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  getCancelButton() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 80),
        child: Center(
          child: Container(
            width: 230,
            height: MediaQuery.of(context).size.height / 15,
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Cancel",
              style: const TextStyle(
                  color: const Color(0xff515151),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xffededed), width: 1),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 2),
                      blurRadius: 3,
                      spreadRadius: 0)
                ],
                color: const Color(0xfffadeac)),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  // 에러 메시지 사용자에게 알림
  void showMsgDialog(String msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 100,
            child: Center(
              child: Text(msg),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              color: Colors.green.shade500,
              child: Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> getPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      //print('허락됨');
      return true;
    } else if (status.isDenied) {
      //print('거절됨');
      await Permission.locationWhenInUse.request(); // 허락해달라고 팝업띄우는 코드
      status = await Permission.locationWhenInUse.status;
      if (status.isGranted) {
        //print('허락됨');
        return true;
      }
    }
    return false;
  }
}

class Pos {
  final double? latitude;
  final double? longitude;

  Pos({
    required this.latitude,
    required this.longitude,
  });
}
