import 'package:equatable/equatable.dart';

import '../../model/report_get_model.dart';

abstract class ReportGetState extends Equatable {}

class Empty extends ReportGetState {
  @override
  List<Object> get props => [];
}

class Loading extends ReportGetState {
  @override
  List<Object> get props => [];
}

class Error extends ReportGetState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends ReportGetState {
  final List<ReportGetModel> reportGet;

  Loaded({
    required this.reportGet,
  });

  @override
  List<Object> get props => [reportGet];
}