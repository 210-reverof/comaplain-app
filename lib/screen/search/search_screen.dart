import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/report_list/report_list_cubit.dart';
import '../../bloc/report_list/report_list_state.dart';
import 'package:intl/intl.dart';
import '../login/login_screen.dart';
import '../report_detail/report_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final Function listUpdate;
  SearchScreen(this.listUpdate);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchTextEditController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool broken = true;
  bool publicSafety = true;
  bool etc = true;

  @override
  void dispose() {
    _searchTextEditController.dispose();
    super.dispose();
  }

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        widget.listUpdate();
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
    return WillPopScope(
      onWillPop: () async {
        widget.listUpdate();

        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfffffcf7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: backButton(),
        ),
        body: GestureDetector(
          onTap: () {
            _searchFocusNode.unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Center(
                    child: Container(
                  padding: EdgeInsets.only(top: 13),
                  child: Text("Search Report",
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

                // 검색창
                searchBar(),

                SizedBox(
                  height: 5.0,
                ),

                // 카테고리 필터
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Color.fromARGB(238, 238, 238, 238),
                  ),
                  child: filterButton(),
                ),

                SizedBox(
                  height: 5.0,
                ),

                Expanded(
                    child: RefreshIndicator(
                        onRefresh: refresh,
                        color: Colors.green,
                        child: _buildBody(
                            "report_list_all",
                            CURRENT_USER.latitude as double,
                            CURRENT_USER.longitude as double)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(String state, num x, num y) {
    // ReportListCubit 호출
    BlocProvider.of<ReportListCubit>(context).reportList(state, x, y);
    // BlocBuilder 리턴
    return BlocBuilder<ReportListCubit, ReportListState>(
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
          final items = state.reports;

          return _buildList(items);
        }

        return Container();
      },
    );
  }

  Widget _buildList(List<dynamic> items) {
    List<dynamic> reports = [];
    items.map((e) {
      String title = e.title.toLowerCase();
      String explanation = e.explanation.toLowerCase();

      if (title.contains(_searchTextEditController.text.toLowerCase()) ||
          explanation.contains(_searchTextEditController.text.toLowerCase())) {
        if (broken == true && e.categoryId == 1) {
          reports.add(e);
        } else if (publicSafety == true && e.categoryId == 2) {
          reports.add(e);
        } else if (etc == true && e.categoryId == 3) {
          reports.add(e);
        }
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
          _searchFocusNode.unfocus();
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
              Row(
                children: [
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
                    width: 5.0,
                  ),

                  // 해결 유무에 따라 solved box 표시
                  item.solved == 1
                      ? Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: new BorderRadius.all(
                                    const Radius.circular(5.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text("solved",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                      textAlign: TextAlign.left),
                                )),
                         
                          ],
                        )
                      : Container()
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

  // 검색
  Widget searchBar() {
    // 댓글 입력
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Flexible(
            child: Form(
              key: _formKey,
              child: TextFormField(
                focusNode: _searchFocusNode,
                controller: _searchTextEditController,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Please enter a search term";
                  }
                  return null;
                },
                onEditingComplete: () {
                  if (_formKey.currentState!.validate()) {
                    print('input search : ' + _searchTextEditController.text);

                    _searchFocusNode.unfocus();

                    setState(() {
                      _searchTextEditController.text =
                          _searchTextEditController.text;
                    });
                  } else {
                    null;
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: GestureDetector(
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  hintText: "Let's solve it?",
                  hintStyle: TextStyle(color: Colors.black26),
                  isDense: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterButton() {
    return Row(children: <Widget>[
      SizedBox(
        width: 20.0,
      ),
      ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            'assets/filter.png',
            fit: BoxFit.contain,
            width: 25,
            height: 25,
          )),
      SizedBox(
        width: 20.0,
      ),
      GestureDetector(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
                width: 60,
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
                    "broken",
                    style: const TextStyle(
                        color: const Color(0xff9ba4a1),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                )),
            AnimatedOpacity(
              opacity: broken ? 1.0 : 0.0,
              duration: Duration(milliseconds: 100),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/category_broken.png',
                        fit: BoxFit.fill,
                        width: 60,
                        height: 25,
                      )),
                  Container(
                    child: Text(
                      "broken",
                      style: const TextStyle(
                          color: const Color(0xffededed),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            broken = !broken;
          });
        },
      ),
      SizedBox(
        width: 20.0,
      ),
      GestureDetector(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
                width: 90,
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
                    "public safety",
                    style: const TextStyle(
                        color: const Color(0xff9ba4a1),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                )),
            AnimatedOpacity(
              opacity: publicSafety ? 1.0 : 0.0,
              duration: Duration(milliseconds: 100),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/category_security.png',
                        fit: BoxFit.fill,
                        width: 90,
                        height: 25,
                      )),
                  Container(
                    child: Text(
                      "public safety",
                      style: const TextStyle(
                          color: const Color(0xffededed),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 12),
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
            publicSafety = !publicSafety;
          });
        },
      ),
      SizedBox(
        width: 20.0,
      ),
      GestureDetector(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
                width: 40,
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
                    "etc",
                    style: const TextStyle(
                        color: const Color(0xff9ba4a1),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                )),
            AnimatedOpacity(
              opacity: etc ? 1.0 : 0.0,
              duration: Duration(milliseconds: 100),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/category_etc.png',
                        fit: BoxFit.fill,
                        width: 40,
                        height: 25,
                      )),
                  Container(
                    child: Text(
                      "etc",
                      style: const TextStyle(
                          color: const Color(0xffededed),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 12),
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
            etc = !etc;
          });
        },
      ),
    ]);
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
