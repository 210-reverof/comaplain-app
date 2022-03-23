import 'package:comaplain/model/comments_list_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReportDetailCommentState extends Equatable {}

class Empty extends ReportDetailCommentState {
  @override
  List<Object> get props => [];
}

class Loading extends ReportDetailCommentState {
  @override
  List<Object> get props => [];
}

class Error extends ReportDetailCommentState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends ReportDetailCommentState {
  final List<CommentsListModel> comments;

  Loaded({
    required this.comments,
  });

  @override
  List<Object> get props => [comments];
}