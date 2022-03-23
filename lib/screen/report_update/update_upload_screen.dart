import 'package:comaplain/bloc/report_detail_image/report_detail_image_cubit.dart';
import 'package:comaplain/bloc/report_detail_image/report_detail_image_state.dart';
import 'package:comaplain/bloc/report_update/report_update_cubit.dart';
import 'package:comaplain/model/report_update_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';

//ReportWritingScreen
class UpdateUploadScreen extends StatefulWidget {
  late int id;
  late int solved;
  late ReportUpdateModel item;

  UpdateUploadScreen(this.id, this.solved, this.item);

  @override
  _UpdateUploadScreenState createState() => _UpdateUploadScreenState();
}

class _UpdateUploadScreenState extends State<UpdateUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
  late List<bool> categoryPicked;
  String currReportTitle = "";
  String currReportExplanation = "";

  Future<void> _pickImg() async {
    final XFile? selectedImages =
        await _picker.pickImage(source: ImageSource.camera);
    if (selectedImages != null) {
      _pickedImgs.add(selectedImages);
    }
    setState(() {});
  }

  bool broken = false;
  bool public_safety = false;
  bool etc = false;

  @override
  void initState() {
    currReportTitle = widget.item.title.toString();
    currReportExplanation = widget.item.explanation.toString();
    categoryPicked = widget.item.category == 1
        ? [true, false, false]
        : widget.item.category == 2
            ? [false, true, false]
            : [false, false, true];
  }

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
              child: Text("Update Report",
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
          widget.solved == 0
              ? getCategoryToggle()
              : Row(
                  children: [
                    SizedBox(width: 20),
                    getCategoryBox((widget.item.category as int) - 1)
                  ],
                ),

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
              child: TextFormField(
                initialValue: widget.item.title,
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
              child: TextFormField(
                initialValue: widget.item.explanation,
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

          Divider(
              height: MediaQuery.of(context).size.height / 120,
              color: const Color(0xfffffcf7)),
          getUpdateButton(),
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
      getCategoryBox(0),
      getCategoryBox(1),
      getCategoryBox(2),
    ]);
  }

  GestureDetector getCategoryBox(int categoryIndexNum) {
    double width = 0;
    String categoryName = "";
    String imgDir = "";

    if (categoryIndexNum == 0) {
      width = 95;
      categoryName = "broken";
      imgDir = 'assets/category_broken.png';
    } else if (categoryIndexNum == 1) {
      width = 142;
      categoryName = "public safety";
      imgDir = 'assets/category_security.png';
    } else {
      width = 58;
      categoryName = "etc";
      imgDir = 'assets/category_etc.png';
    }
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
            opacity: categoryPicked[categoryIndexNum] ? 1.0 : 0.0, // 2
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
          categoryPicked[categoryIndexNum] = true;
        });
      },
    );
  }

  Row getImageUploader() {
    // ReportDetailImageCubit 호출
    BlocProvider.of<ReportDetailImageCubit>(context)
        .reportDetailImage(widget.id, widget.solved == 0 ? "" : "solved_");

    return Row(
      children: [
        SizedBox(width: 20),

        // BlocBuilder 리턴
        BlocBuilder<ReportDetailImageCubit, ReportDetailImageState>(
          builder: (_, state) {
            if (state is Empty) {
              return Container();
            } else if (state is Error) {
              return Container(
                child: Text(state.message),
              );
            } else if (state is Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is Loaded) {
              final items = state.images;
              return getImageBox(items);
            }

            return Container();
          },
        )
      ],
    );
  }

  getImageBox(items) {
    List<String> images = [];
    items.map((e) {
      images.add("http://34.64.175.9/${e.image}");
    }).toList();

    return Expanded(
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
                      width: MediaQuery.of(context).size.height / 9,
                      height: MediaQuery.of(context).size.height / 9,
                      decoration: index <= images.length - 1
                          ? BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.5)),
                              border: Border.all(
                                  color: const Color(0xffdbdbdb), width: 1.5),
                              color: const Color(0xffffffff))
                          : BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.5)),
                              border: Border.all(
                                  color: const Color(0xffdbdbdb), width: 1.5),
                              color: const Color(0xffffffff)),
                      child: index <= images.length - 1
                          ? Image.network(
                              images[index],
                              fit: BoxFit.cover,
                            )
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
    );
  }

  // To Do:
// bloc 사용
// RegisterButton 클릭하면 사진, 선택된 카테고리, title, explanation 데이터들 DB로 전송
// 데이터 없으면 업뎃 안되도록
  getUpdateButton() {
    return GestureDetector(
      child: Center(
        child: Container(
          width: 230,
          height: MediaQuery.of(context).size.height / 15,
          padding: EdgeInsets.all(12.0),
          child: Text(
            "update",
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
          //errorMsg = "사진은 필수 입력 항목입니다.";
        } else if (currReportTitle == "") {
          errorMsg = "제목은 필수 입력 항목입니다.";
        } else if (currReportExplanation == "") {
          errorMsg = "내용은 필수 입력 항목입니다.";
        }
        // 필수 입력 항목을 모두 작성했다면 getImage() 실행
        if (errorMsg == "") {
          ReportUpdateModel currReport = ReportUpdateModel(
              title: currReportTitle,
              explanation: currReportExplanation,
              category: categoryPicked[0]
                  ? 1
                  : categoryPicked[1]
                      ? 2
                      : 3);
          await BlocProvider.of<ReportUpdateCubit>(context).createReportText(
              widget.id, widget.solved, currReport, _pickedImgs);

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
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 80),
        child: Center(
          child: Container(
            width: 230,
            height: MediaQuery.of(context).size.height / 15,
            padding: EdgeInsets.all(12.0),
            child: Text(
              "cancel",
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
