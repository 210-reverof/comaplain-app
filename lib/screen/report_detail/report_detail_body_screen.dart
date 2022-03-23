import 'package:comaplain/bloc/report_recommendation/report_recommendation_cubit.dart';
import 'package:comaplain/bloc/report_recommendation/report_recommendation_state.dart';
import 'package:comaplain/model/report_detail_body_model.dart';
import 'package:comaplain/model/report_recommendation_create_model.dart';
import 'package:comaplain/model/report_update_model.dart';
import 'package:comaplain/screen/login/login_screen.dart';
import 'package:comaplain/screen/map/map_screen.dart';
import 'package:comaplain/screen/report_detail/report_detail_image_screen.dart';
import 'package:comaplain/screen/report_update/report_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../bloc/bottom_navi/navigation_cubit.dart';
import '../../bloc/report_detail_body/report_detail_body_cubit.dart';
import '../../bloc/report_detail_body/report_detail_body_state.dart';
import '../../bloc/report_list/report_list_cubit.dart';
import '../my_page/user_report_list_screen.dart';
import '../solve_writing/solve_write_screen.dart';
import 'report_detail_comment_screen.dart';
import 'package:intl/intl.dart';

class ReportDetailBodyScrren extends StatefulWidget {
  final int id;
  final Function listUpdate;
  ReportDetailBodyScrren(this.id, this.listUpdate);

  @override
  _ReportDetailBodyScrrenState createState() => _ReportDetailBodyScrrenState();
}

class _ReportDetailBodyScrrenState extends State<ReportDetailBodyScrren> {
  var _tabTextIndexSelected = 0;

  @override
  Widget build(BuildContext context) {
    // ReportDetailBodyCubit 호출
    BlocProvider.of<ReportDetailBodyCubit>(context).reportDetail(widget.id);
    BlocProvider.of<ReportRecommendationCubit>(context).recommendationList();

    // RefreshIndicator 리턴
    return RefreshIndicator(
      backgroundColor: const Color(0xfffffcf7),
      onRefresh: reFresh,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    // BlocBuilder 리턴
    return BlocBuilder<ReportDetailBodyCubit, ReportDetailBodyState>(
      builder: (context, state) {
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
          ReportDetailBodyModel items = state.reportDetails;
          // 사용자가 추천했는지 확인
          return buildRecommentdation(items);
        }

        return Container();
      },
    );
  }

  // 추천 확인
  Widget buildRecommentdation(dynamic items) {
    return BlocBuilder<ReportRecommendationCubit, ReportRecommendationState>(
      builder: (context, state) {
        if (state is RecommendationEmpty) {
          return Container();
        } else if (state is RecommendationError) {
          return Container(
            child: Text(state.message),
          );
        } else if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is RecommendationLoaded) {
          List<dynamic> recommendationItems = state.recommendations;
          List<String> recommendationItem = [];
          recommendationItems.map((e) {
            if (e.report == items.id &&
                e.user == CURRENT_USER.firebaseUID.toString()) {
              recommendationItem.add("추천 했어요~");
            }
          }).toList();

          print("추천 했나요? : $recommendationItem");

          // buildList 리턴
          return buildList(items, recommendationItem);
        }

        return Container();
      },
    );
  }

  Widget buildList(dynamic item, List<String> recommendationItem) {
    print("현재 게시글 id : ${item.id}");
    print("현재 게시글 report uid : ${item.user.toString()}");
    print("현재 게시글 solved uid : ${item.solvedUser.toString()}");
    print("현재 사용자 uid: ${CURRENT_USER.firebaseUID.toString()}");

    // item => Report info
    // CustomScrollView 리턴
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: <Widget>[
        // 헤더 영역
        SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 350.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            pinned: false,

            // 게시글 해결유무에 따라 ReportDetailImageScreen 호출
            flexibleSpace: item.solved == 0
                ? ReportDetailImageScreen(widget.id, "")
                : _tabTextIndexSelected == 0
                    ? ReportDetailImageScreen(widget.id, "solved_")
                    : ReportDetailImageScreen(widget.id, ""),
            actions: <Widget>[
              // 지도 버튼
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Image.asset(
                    'assets/mark.png',
                    height: 25,
                    width: 25,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MapScreen(item.latitude, item.longitude)));
                },
              ),
              if (item.solved == 0)

                // 현재 게시글 Report UID와 사용자가 같으면 게시글 수정 버튼 활성화
                if (CURRENT_USER.firebaseUID == item.user)
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      menuButton(widget.id, item.solved, item);
                    },
                  )
                else
                  SizedBox(
                    width: 10.0,
                  )
              else
              // 현재 게시글 Solved UID와 사용자가 같으면 게시글 수정 버튼 활성화
              if (CURRENT_USER.firebaseUID == item.solvedUser)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    menuButton(widget.id, item.solved, item);
                  },
                )
              else
                SizedBox(
                  width: 10.0,
                )
            ]),

        // 설명
        SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
                color: const Color(0xfffffcf7),
                child: _buildListItem(item, widget.id, recommendationItem))),
      ],
    );
  }

  Widget _buildListItem(dynamic item, int id, List<String> recommendationItem) {
    // 신고 날짜
    DateTime createdDate = DateTime.parse(item.createdAt);
    String reportDate = DateFormat.yMMMd().format(createdDate);

    // 해결 날짜
    DateTime solvedCreatedDate = DateTime.parse(item.solvedUpdatedAt);
    String solvedDate = DateFormat.yMMMd().format(solvedCreatedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.only(left: 30.0),
          leading: InkWell(
            onTap: () {
              if (item.solved == 0) {
                Navigator.pushNamed(context, '/UserReportListScreen',
                    arguments: UserReportListArguments(
                        uid: item.user.toString(),
                        appName: item.appName.toString(),
                        googleProfileImage:
                            item.googleProfileImage.toString()));
              } else {
                if (_tabTextIndexSelected == 0) {
                  Navigator.pushNamed(context, '/UserReportListScreen',
                      arguments: UserReportListArguments(
                          uid: item.solvedUser.toString(),
                          appName: item.solvedAppName.toString(),
                          googleProfileImage:
                              item.solvedGoogleProfileImage.toString()));
                } else {
                  Navigator.pushNamed(context, '/UserReportListScreen',
                      arguments: UserReportListArguments(
                          uid: item.user.toString(),
                          appName: item.appName.toString(),
                          googleProfileImage:
                              item.googleProfileImage.toString()));
                }
              }
            },

            // 구글 프로필 이미지
            child: CircleAvatar(
              backgroundImage: item.solved == 0
                  ? NetworkImage(item.googleProfileImage)
                  : _tabTextIndexSelected == 0
                      ? NetworkImage(item.solvedGoogleProfileImage)
                      : NetworkImage(item.googleProfileImage),
            ),
          ),

          // 닉네임
          title: InkWell(
            onTap: () {
              if (item.solved == 0) {
                Navigator.pushNamed(context, '/UserReportListScreen',
                    arguments: UserReportListArguments(
                        uid: item.user.toString(),
                        appName: item.appName.toString(),
                        googleProfileImage:
                            item.googleProfileImage.toString()));
              } else {
                if (_tabTextIndexSelected == 0) {
                  Navigator.pushNamed(context, '/UserReportListScreen',
                      arguments: UserReportListArguments(
                          uid: item.solvedUser.toString(),
                          appName: item.solvedAppName.toString(),
                          googleProfileImage:
                              item.solvedGoogleProfileImage.toString()));
                } else {
                  Navigator.pushNamed(context, '/UserReportListScreen',
                      arguments: UserReportListArguments(
                          uid: item.user.toString(),
                          appName: item.appName.toString(),
                          googleProfileImage:
                              item.googleProfileImage.toString()));
                }
              }
            },
            child: Text(
              item.solved == 0
                  ? item.appName
                  : _tabTextIndexSelected == 0
                      ? item.solvedAppName
                      : item.appName,
              style: TextStyle(fontSize: 14),
            ),
          ),

          // 등록 날짜
          subtitle: Text(
            item.solved == 0
                ? reportDate
                : _tabTextIndexSelected == 0
                    ? solvedDate
                    : reportDate,
            style: TextStyle(fontSize: 12),
          ),
        ),
        // 구분선
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Divider(
            thickness: 1,
          ),
        ),

        SizedBox(
          height: 12.0,
        ),

        // 게시글 해결유무에 따라 getToggleBtn/solve 버튼 호출
        item.solved == 1
            ? getToggleBtn()
            :
            // solve 버튼
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SolveWriteScreen(id, item.category)));
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset('assets/btn_solve.png',
                              fit: BoxFit.fill,
                              height: 40,
                              width: MediaQuery.of(context).size.width),
                        ),
                        Text(
                          "solve",
                          style: const TextStyle(
                              color: const Color(0xffededed),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

        SizedBox(
          height: 15.0,
        ),

        // 신고 종류
        Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              item.category == 1
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/category_broken.png',
                        fit: BoxFit.fill,
                        height: 25,
                        width: 60,
                      ))
                  : item.category == 2
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
              Text(
                  item.category == 1
                      ? "broken"
                      : item.category == 2
                          ? "public safety"
                          : "etc",
                  style: const TextStyle(
                      color: const Color(0xffededed),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  textAlign: TextAlign.left),
            ],
          ),
        ),

        SizedBox(
          height: 20.0,
        ),

        // 신고 제목
        Container(
            padding: EdgeInsets.only(left: 40.0),
            width: double.infinity,
            child: Text("Title",
                style: const TextStyle(
                    color: const Color(0xff191919),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 16),
                textAlign: TextAlign.left)),

        SizedBox(
          height: 5,
        ),
        Container(
            padding: EdgeInsets.only(left: 40.0, right: 40.0),
            width: double.infinity,
            child: Text(
                item.solved == 0
                    ? item.title
                    : _tabTextIndexSelected == 0
                        ? item.solvedTitle
                        : item.title,
                style: const TextStyle(
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.w400,
                    fontFamily: "SegoeUI",
                    fontStyle: FontStyle.normal,
                    fontSize: 12),
                textAlign: TextAlign.left)),

        SizedBox(
          height: 20,
        ),

        // 신고 설명
        Container(
            padding: EdgeInsets.only(left: 40.0),
            width: double.infinity,
            child: Text("Explanation",
                style: const TextStyle(
                    color: const Color(0xff191919),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 16),
                textAlign: TextAlign.left)),

        SizedBox(
          height: 5,
        ),

        Container(
            padding: EdgeInsets.only(left: 40.0, right: 40.0),
            width: double.infinity,
            child: Text(
                item.solved == 0
                    ? item.explanation
                    : _tabTextIndexSelected == 0
                        ? item.solvedExplanation
                        : item.explanation,
                style: const TextStyle(
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.w400,
                    fontFamily: "SegoeUI",
                    fontStyle: FontStyle.normal,
                    fontSize: 12),
                textAlign: TextAlign.left)),

        SizedBox(
          height: 12.0,
        ),

        // 공감 개수
        InkWell(
          onTap: () {
            // 공감 버튼
            reportRecommendationDialog(item, recommendationItem);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 사용자가 공감했는지에 따라 Icon 변경
                recommendationItem.length == 0
                    ? Icon(
                        Icons.favorite_border,
                        color: Colors.pink,
                        size: 20,
                      )
                    : Icon(
                        Icons.favorite,
                        color: Colors.pink,
                        size: 20,
                      ),
                SizedBox(
                  width: 3.0,
                ),
                Text(
                  item.recommendation.toString(),
                  style: TextStyle(color: Colors.pink, fontSize: 14),
                )
              ],
            ),
          ),
        ),

        SizedBox(
          height: 12.0,
        ),

        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Divider(
            thickness: 1,
          ),
        ),

        // 댓글
        Container(
            padding: EdgeInsets.only(left: 40.0),
            width: double.infinity,
            child: Text("Comments",
                style: const TextStyle(
                    color: const Color(0xff191919),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.7),
                textAlign: TextAlign.left)),

        SizedBox(
          height: 20.0,
        ),

        // 댓글 정보 => ReportDetailCommentScreen 호출
        Expanded(child: ReportDetailCommentScreen(widget.id)),
        SizedBox(
          height: 100.0,
        ),
      ],
    );
  }

  // 메뉴 버튼
  Future menuButton(int id, int solved, ReportDetailBodyModel item) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0), // 적절히 조절
                topRight: const Radius.circular(25.0), // 적절히 조절
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                ListTile(
                    title: new Text(
                      'Changing information',
                      style: TextStyle(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    subtitle: Text("Edit your report!",
                        style: TextStyle(fontSize: 12)),
                    onTap: () {},
                    trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        // to report update model
                        ReportUpdateModel updateModel = ReportUpdateModel(
                          title: solved == 0 ? item.title : item.solvedTitle,
                          explanation: solved == 0 ? item.explanation : item.solvedExplanation,
                          category: item.category
                        );

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReportUpdateScreen(id, solved, updateModel)));
                      },
                    )),
                ListTile(
                    title: new Text(
                      'Delete report',
                      style: TextStyle(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    onTap: () {
                      reportDeleteDialog();
                    },
                    trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        reportDeleteDialog();
                      },
                    )),
                ListTile(
                    title: new Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ],
            ),
          );
        });
  }

  // 삭제 버튼
  reportDeleteDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete'),
        content: Text(
          'Are you sure you want to delete the selected reports?',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(
              'Ok',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () async {
              // 게시물 삭제
              await BlocProvider.of<ReportListCubit>(context)
                  .reportDelete(widget.id);

              // NavigationCubit 호출 => NavbarItem.reportList
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavbarItem.reportList);

              // 지금까지 모든 페이지를 스택에서 삭제하고 RootScreen으로 이동
              Navigator.pushNamedAndRemoveUntil(
                  context, '/RootScreen', (_) => false);
            },
          ),
        ],
      ),
    );
  }

  // 공감 버튼
  reportRecommendationDialog(dynamic item, List<String> recommendationItem) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sympathy'),
        content: Text(
          'Would you like to sympathize with this report?',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(
              'Ok',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () async {
              // 사용자가 공감했는지에 따라 수행
              if (recommendationItem.length == 0) {
                // 공감++
                ReportRecommendationCreateModel
                    reportRecommendationCreateModel =
                    ReportRecommendationCreateModel(
                        user: CURRENT_USER.firebaseUID.toString(),
                        report: item.id);
                await BlocProvider.of<ReportRecommendationCubit>(context)
                    .recommendationCreate(reportRecommendationCreateModel);

                // ReportListScreen 업데이트
                widget.listUpdate();

                Navigator.pop(context);
                setState(() {
                  // build 업데이트
                });
              } else {
                // 이미 공감한 글이라면 toast를 띄움
                Navigator.pop(context);
                flutterToast();
              }
            },
          ),
        ],
      ),
    );
  }

  getToggleBtn() {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 0, 8, 0), // 가운데 정렬이 안되어있어서 임의로 양쪽 마진
      width: 316,
      height: 46,
      child: Stack(children: [
        Image.asset(
          _tabTextIndexSelected == 0
              ? "assets/view_toggle_solved.png"
              : "assets/view_toggle_report.png",
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

  void flutterToast() {
    // 토스트 메시지를 출력하기 위한 함수 생성
    Fluttertoast.showToast(
        msg:
            "This is a report that has already been sympathized with.", // 토스트 메시지 내용
        gravity: ToastGravity.CENTER, // 가운데로 안나오네요..
        fontSize: 14.0,
        toastLength: Toast.LENGTH_SHORT // 토스트 메시지 지속시간 짧게
        );
  }

  Future reFresh() async {
    // await Future.delayed(Duration(seconds: 1)); //thread sleep 같은 역할을 함.
    setState(() {
      // build 업데이트
    });
  }
}
