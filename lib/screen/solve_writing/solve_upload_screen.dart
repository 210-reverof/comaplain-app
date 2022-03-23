import 'package:comaplain/bloc/solve_write/solve_write_cubit.dart';
import 'package:comaplain/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../../model/solve_write_model.dart';

//ReportWritingScreen
class SolveUploadScreen extends StatefulWidget {
  final int id;
  final int category;

  SolveUploadScreen(this.id, this.category);

  @override
  _SolveUploadScreenState createState() => _SolveUploadScreenState();
}

class _SolveUploadScreenState extends State<SolveUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _pickedImgs = [];
  List<bool> categoryPicked = [false, false, false];
  String currReportTitle = "";
  String currReportExplanation = "";
  DateTime now = DateTime.now();

  Future<void> _pickImg() async {
    final XFile? selectedImages =
        await _picker.pickImage(source: ImageSource.camera);
    if (selectedImages != null) {
      _pickedImgs.add(selectedImages);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 카테고리 확인!
    categoryPicked[widget.category - 1] = true;

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
              padding: EdgeInsets.only(top: 13),
              child: Text("Solve",
                  style: const TextStyle(
                      color: const Color(0xff2e2e2e),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 70.0 / 3),
                  textAlign: TextAlign.left),
            ),
          ),

          Divider(height: 14, color: const Color(0xfffffcf7)),
          // picture uploader
          getImageUploader(),

          Divider(height: 13, color: const Color(0xfffffcf7)),
          getCategoryToggle(),

          Divider(height: 15, color: const Color(0xfffffcf7)),
          getLabel("Title"),

          Padding(
            padding: EdgeInsets.fromLTRB(30, 7, 30, 7),
            child: Container(
              padding: EdgeInsets.fromLTRB(18, 15, 15, 7),
              height: 55,
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

          Divider(height: 12, color: const Color(0xfffffcf7)),
          getLabel("Explanation"),

          Padding(
            padding: EdgeInsets.fromLTRB(30, 7, 30, 7),
            child: Container(
              height: 170,
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
                  });
                },
              ),
            ),
          ),

          Divider(height: 12, color: const Color(0xfffffcf7)),
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
      categoryPicked[0] == true
          ? getCategoryBox(95, 0, 'broken', 'assets/category_broken.png')
          : categoryPicked[1] == true
              ? getCategoryBox(
                  142, 1, 'public safety', 'assets/category_security.png')
              : getCategoryBox(58, 2, 'etc', 'assets/category_etc.png'),
    ]);
  }

  Widget getCategoryBox(
      double width, int categoryNum, String categoryName, String imgDir) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
                width: width, //58
                height: 38,
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
                  height: 38,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(imgDir)), //'assets/category_etc.png'
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
                width: 85,
                height: 85,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 85,
                      height: 85,
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
                  width: 85,
                  height: 85,
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

  // To Do:
// bloc 사용
// RegisterButton 클릭하면 사진, 선택된 카테고리, title, explanation 데이터들 DB로 전송
// 데이터 없으면 업뎃 안되도록
  getRegisterButton() {
    return GestureDetector(
      child: Center(
        child: Container(
          width: 230,
          height: 50,
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
          // 지금까지 모든 페이지를 스택에서 삭제하고 RootScreen으로 이동
          SolveWriteModel currReport = SolveWriteModel(
              solvedUser: CURRENT_USER.firebaseUID,
              solvedAppName: CURRENT_USER.appName,
              solvedGoogleProfileImage: CURRENT_USER.googleProfileImage,
              solvedTitle: currReportTitle,
              solvedExplanation: currReportExplanation,
              solved: 1,
              solvedCreatedAt: now.toString());

          await BlocProvider.of<SolveWriteCubit>(context)
              .createSolveText(currReport, _pickedImgs, widget.id);
          Navigator.pushNamedAndRemoveUntil(
              context, '/RootScreen', (_) => false);

          // 필수 입력 항목을 작성하지 않았다면 dialog 실행
        } else {
          showMsgDialog(errorMsg);
        }
      },
    );
  }

  getCancelButton() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(top: 9),
        child: Center(
          child: Container(
            width: 230,
            height: 50,
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
}
