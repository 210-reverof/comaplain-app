import 'package:comaplain/bloc/user_report_list/user_report_list_state.dart';
import 'package:comaplain/model/user_report_list_model.dart';
import 'package:comaplain/screen/my_page/report_count_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_report_list/user_report_list_cubit.dart';
import '../report_detail/report_detail_screen.dart';
import 'package:intl/intl.dart';

class UserReportListArguments {
  final String uid;
  final String appName;
  final String googleProfileImage;
  UserReportListArguments(
      {required this.uid,
      required this.appName,
      required this.googleProfileImage});
}

class UserReportListScreen extends StatefulWidget {
  const UserReportListScreen({Key? key}) : super(key: key);

  @override
  _UserReportListScreenState createState() => _UserReportListScreenState();
}

class _UserReportListScreenState extends State<UserReportListScreen> {
  var _tabTextIndexSelected = 0;
  var _listTextTabToggle = ["reports", "solved"];
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

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UserReportListArguments;

    print("uid : ${args.uid} 를 가진 사용자의 게시물");

    return Scaffold(
      backgroundColor: const Color(0xfffffcf7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: backButton(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Center(
                child: Container(
              padding: EdgeInsets.only(top: 13),
              child: Text("Reports List",
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
            Column(
              children: [
                // 이미지
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage:
                      NetworkImage(args.googleProfileImage.toString()),
                ),

                SizedBox(
                  height: 20.0,
                ),

                // 닉네임
                Text(
                  args.appName.toString(),
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(
                  height: 5.0,
                ),

                // 신고 글 개수
                ReportCountScreen(args.uid),
              ],
            ),

            SizedBox(
              height: 15.0,
            ),
            getToggleBtn(),

            SizedBox(
              height: 15.0,
            ),

            _tabTextIndexSelected == 0
                // 미해결된 게시글
                ? Expanded(
                    child: RefreshIndicator(
                        onRefresh: refresh,
                        color: Colors.green,
                        child: _buildBody(args.uid.toString(), 0)))
                // 해결된 게시글
                : Expanded(
                    child: RefreshIndicator(
                        onRefresh: refresh,
                        color: Colors.green,
                        child: _buildBody(
                          args.uid.toString(),
                          1,
                        )))
          ],
        ),
      ),
    );
  }

  Widget _buildBody(String uid, int solved) {
    // UserReportListCubit 호출
    BlocProvider.of<UserReportListCubit>(context).userReportList(uid);
    // BlocBuilder 리턴
    return BlocBuilder<UserReportListCubit, UserReportListState>(
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
          final items = state.userReports;

          return _buildList(items, uid, solved);
        }

        return Container();
      },
    );
  }

  Widget _buildList(List<dynamic> items, String id, int solved) {
    // 해결된 게시글인지 미해결된 게시글인지 확인
    List<UserReportListModel> reports = [];
    items.map((e) {
      if (e.solved == solved) {
        reports.add(e);
      }
    }).toList();

    //reports => 게시글
    // 게시글이 없는 경우
    if (reports.length == 0) {
      return Center(child: Text("There are no posts to show"));
    } else {
      // 게시글이 있다면 ListView 리턴
      return ListView(
        children: reports.map((e) {
          return _buildListItem(e);
        }).toList(),
      );
    }
  }

  Widget _buildListItem(item) {
    // 신고 날짜
    DateTime createdDate = DateTime.parse(item.createdAt);
    String reportDate = DateFormat.yMMMd().format(createdDate);

    // 해결 날짜
    DateTime solvedCreatedDate = DateTime.parse(item.solvedCreatedAt);
    String solvedDate = DateFormat.yMMMd().format(solvedCreatedDate);

    return Card(
      elevation: 2,
      child: InkWell(
        // 게시글을 눌렀을 때 ReportDetailScreen으로 이동
        onTap: () {
          Navigator.pushNamed(context, '/ReportDetailScreen',
              arguments:
                  ReportDetilArguments(id: item.id, listUpdate: listUpdate));
        },
        onLongPress: () {},
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 신고 종류
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  item.content == "broken"
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            'assets/category_broken.png',
                            fit: BoxFit.fill,
                            height: 25,
                            width: 60,
                          ))
                      : item.content == "public safety"
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/category_security.png',
                                fit: BoxFit.fill,
                                height: 25,
                                width: 90,
                              ))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/category_etc.png',
                                fit: BoxFit.fill,
                                height: 25,
                                width: 40,
                              )),
                  Text(item.content,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0),
                      textAlign: TextAlign.left),
                ],
              ),

              SizedBox(
                height: 10.0,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 게시글의 대표 이미지
                  Container(
                    child: Image.network(
                      "http://34.64.175.9/${item.image}",
                      fit: BoxFit.cover,
                    ),
                    height: 120.0,
                    width: 120.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // 제목
                          Container(
                            child: Text(
                                item.solved == 0
                                    ? item.title
                                    : item.solvedTitle,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true),
                          ),

                          SizedBox(
                            height: 5.0,
                          ),

                          // 설명
                          Text(
                              item.solved == 0
                                  ? item.explanation
                                  : item.solvedExplanation,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true),

                          SizedBox(
                            height: 10.0,
                          ),

                          // 날짜
                          Text(item.solved == 0 ? reportDate : solvedDate,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              // 추천
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Colors.pink,
                    size: 16,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    item.recommendation.toString(),
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 12,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getToggleBtn() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0), // 가운데 정렬이 안되어있어서 임의로 양쪽 마진
      width: 316,
      height: 46,
      child: Stack(children: [
        Image.asset(
          _tabTextIndexSelected == 0
              ? "assets/reports_toggle_reports.png"
              : "assets/reports_toggle_solved.png",
          fit: BoxFit.fill,
        ),
        Positioned(
            left: 0,
            top: 0,
            child: GestureDetector(
              child: Container(
                width: 157,
                height: 46,
                color: Color.fromARGB(00, 00, 00, 00),
              ),
              onTap: () {
                setState(() {
                  _tabTextIndexSelected = 0;
                });
              },
            )),
        Positioned(
            left: 159,
            top: 0,
            child: GestureDetector(
              child: Container(
                width: 157,
                height: 46,
                color: Color.fromARGB(00, 00, 00, 00),
              ),
              onTap: () {
                setState(() {
                  _tabTextIndexSelected = 1;
                });
              },
            ))
      ]),
    );
  }

  listUpdate() {
    setState(() {});
  }

  // build 업데이트
  Future refresh() async {
    await Future.delayed(Duration(seconds: 1)); //thread sleep 같은 역할을 함.

    setState(() {
      // build 업데이트
    });
  }
}
