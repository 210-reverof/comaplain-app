import 'package:comaplain/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/report_detail_comment/report_detail_comment_cubit.dart';
import '../../bloc/report_detail_comment/report_detail_comment_state.dart';
import '../my_page/user_report_list_screen.dart';
import 'package:intl/intl.dart';

class ReportDetailCommentScreen extends StatefulWidget {
  final int id;
  ReportDetailCommentScreen(this.id);

  @override
  _ReportDetailCommentScreenState createState() =>
      _ReportDetailCommentScreenState();
}

class _ReportDetailCommentScreenState extends State<ReportDetailCommentScreen> {
  @override
  Widget build(BuildContext context) {
    // CommentListCubit 호출
    BlocProvider.of<ReportDetailCommentCubit>(context).commentsList(widget.id);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    // BlocBuilder 리턴
    return BlocBuilder<ReportDetailCommentCubit, ReportDetailCommentState>(
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
          final items = state.comments;

          return _bildList(context, items);
        }

        return Container();
      },
    );
  }

  Widget _bildList(BuildContext context, List<dynamic> items) {
    //items => 댓글
    // 댓글이 없는 경우
    if (items.length == 0) {
      return Center(child: Text("No comments"));
    } else {
      // _buildListItem 리턴
      return Column(
        children: items.map((e) {
          return Expanded(child: _buildListItem(context, e));
        }).toList(),
      );
    }
  }

  Widget _buildListItem(BuildContext context, dynamic item) {
    DateTime createdDate = DateTime.parse(item.createdAt);
    String reportDate = DateFormat.yMMMd().format(createdDate);
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: ListTile(
              dense: true,
              leading: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/UserReportListScreen',
                      arguments: UserReportListArguments(
                          uid: item.firebaseUid.toString(),
                          appName: item.appName.toString(),
                          googleProfileImage:
                              item.googleProfileImage.toString()));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(item.googleProfileImage),
                ),
              ),

              // 닉네임
              title: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/UserReportListScreen',
                      arguments: UserReportListArguments(
                          uid: item.firebaseUid.toString(),
                          appName: item.appName.toString(),
                          googleProfileImage:
                              item.googleProfileImage.toString()));
                },
                child: Text(
                  item.appName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),

                  // 내용
                  Text(item.content,
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.visible,
                      softWrap: true),

                  SizedBox(
                    height: 10,
                  ),
                  // 등록 날짜
                  Text(
                    reportDate,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),

              // 유저 정보와 댓글 작성자 정보가 같으면 삭제 버튼 생성
              trailing: CURRENT_USER.firebaseUID.toString() == item.firebaseUid
                  ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Delete'),
                            content: Text(
                              'Are you sure you want to delete the selected comment?',
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  'Cencel',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                onPressed: () async {
                                  // 댓글 삭제
                                  await BlocProvider.of<
                                          ReportDetailCommentCubit>(context)
                                      .commentDelete(item.id);
                                  Navigator.pop(context);
                                  setState(() {
                                    // build 업데이트
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          child: Divider(
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
