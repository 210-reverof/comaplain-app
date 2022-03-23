
import 'package:bloc/bloc.dart';
import 'package:comaplain/model/comments_create_model.dart';
import 'package:comaplain/repository/report_detail_comment_repository.dart';
import 'report_detail_comment_state.dart';

class ReportDetailCommentCubit extends Cubit<ReportDetailCommentState> {
  final ReportDetailCommentRepository repository;

  // 초기 값
  ReportDetailCommentCubit({required this.repository}) : super(Empty());

  // 댓글 보기
  commentsList(int id) async {
    try {
      emit(Loading());

      final resp = await repository.listComments(id);

      emit(Loaded(comments: resp));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  // 댓글 추가
  commentCreate(CommentsCreateModel commentsCreateModel) async {
    try {
      await repository.createComments(commentsCreateModel);
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  // 댓글 삭제
  commentDelete(int id) async {
    try {
      await repository.deleteComments(id);
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
