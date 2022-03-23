import 'package:comaplain/bloc/user_report_list/user_report_list_cubit.dart';
import 'package:comaplain/bloc/user_report_list/user_report_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCountScreen extends StatefulWidget {
  final String id;
  ReportCountScreen(this.id);

  @override
  _ReportCountScreenState createState() => _ReportCountScreenState();
}

class _ReportCountScreenState extends State<ReportCountScreen> {
  @override
  Widget build(BuildContext context) {
    // ReportGetCubit 호출
    BlocProvider.of<UserReportListCubit>(context).userReportList(widget.id);

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
            child: Text("0 reports", style: TextStyle(fontSize: 12)),
          );
        } else if (state is Loaded) {
          final items = state.userReports;

          return _buildBody(items, widget.id);
        }

        return Container();
      },
    );
  }
}

Widget _buildBody(List<dynamic> items, String id) {
  

  // items => 게시글
  // 게시글이 없는 경우
  if (items.length == 0) {
    return Text("0 reports", style: TextStyle(fontSize: 12));
  }
  // 게시글이 있다면 개수를 출력
  else {
    return Text("${items.length} reports", style: TextStyle(fontSize: 12));
  }
}
