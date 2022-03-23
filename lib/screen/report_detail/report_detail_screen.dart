import 'package:comaplain/model/comments_create_model.dart';
import 'package:comaplain/screen/login/login_screen.dart';
import 'package:comaplain/screen/report_detail/report_detail_body_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/report_detail_comment/report_detail_comment_cubit.dart';

class ReportDetilArguments {
  final int id;
  final Function listUpdate;
  ReportDetilArguments({required this.id, required this.listUpdate});
}

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({Key? key}) : super(key: key);

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final _commentFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _commentTextEditController = TextEditingController();

  @override
  void dispose() {
    _commentTextEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ReportDetilArguments;
    return Scaffold(
        backgroundColor: const Color(0xfffffcf7),
        body: Stack(children: [
          GestureDetector(
              onTap: () {
                _commentFocusNode.unfocus();
              },
              child: ReportDetailBodyScrren(args.id, args.listUpdate)),

          // 댓글 입력란
          commentEnter(args.id)
        ]));
  }

  // 댓글 입력란
  Widget commentEnter(int id) {
    // 댓글 입력
    return Align(
      child: Container(
        color: const Color(0xfffffcf7),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Flexible(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    focusNode: _commentFocusNode,
                    controller: _commentTextEditController,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please comment.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xfffffcf7),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      hintText: "Please enter your comments.",
                      hintStyle: TextStyle(color: Colors.black26),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          String commentText = _commentTextEditController.text;
                          print('input comment: ' +
                              _commentTextEditController.text);

                          if (_formKey.currentState!.validate()) {
                            CommentsCreateModel commentsCreateModel =
                                CommentsCreateModel(
                                    content: commentText,
                                    user: CURRENT_USER.firebaseUID.toString(),
                                    report: id);

                            await BlocProvider.of<ReportDetailCommentCubit>(
                                    context)
                                .commentCreate(commentsCreateModel);

                            _commentTextEditController.clear();
                            _commentFocusNode.unfocus();
                            setState(() {
                              // build 업데이트
                            });
                          } else {
                            null;
                          }
                        },
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}
