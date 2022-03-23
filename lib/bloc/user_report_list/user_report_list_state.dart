import 'package:equatable/equatable.dart';
import '../../model/user_report_list_model.dart';

abstract class UserReportListState extends Equatable {}

class Empty extends UserReportListState {
  @override
  List<Object> get props => [];
}

class Loading extends UserReportListState {
  @override
  List<Object> get props => [];
}

class Error extends UserReportListState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends UserReportListState {
  final List<UserReportListModel> userReports;

  Loaded({
    required this.userReports,
  });

  @override
  List<Object> get props => [userReports];
}