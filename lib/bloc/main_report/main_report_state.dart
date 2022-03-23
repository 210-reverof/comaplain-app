import 'package:comaplain/model/main_report_model.dart';
import 'package:equatable/equatable.dart';

abstract class MainReportState extends Equatable {}

class Empty extends MainReportState {
  @override
  List<Object> get props => [];
}

class Loading extends MainReportState {
  @override
  List<Object> get props => [];
}

class Error extends MainReportState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends MainReportState {
  List<MainReportModel> mainReports;

  Loaded({
    required this.mainReports,
  });

  @override
  List<Object> get props => [mainReports];
}