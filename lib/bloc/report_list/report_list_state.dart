import 'package:comaplain/model/report_list_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReportListState extends Equatable {}

class Empty extends ReportListState {
  @override
  List<Object> get props => [];
}

class Loading extends ReportListState {
  @override
  List<Object> get props => [];
}

class Error extends ReportListState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends ReportListState {
  final List<ReportListModel> reports;

  Loaded({
    required this.reports,
  });

  @override
  List<Object> get props => [reports];
}