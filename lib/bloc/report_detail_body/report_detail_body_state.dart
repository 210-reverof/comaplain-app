import 'package:equatable/equatable.dart';
import '../../model/report_detail_body_model.dart';

abstract class ReportDetailBodyState extends Equatable {}

class Empty extends ReportDetailBodyState {
  @override
  List<Object> get props => [];
}

class Loading extends ReportDetailBodyState {
  @override
  List<Object> get props => [];
}

class Error extends ReportDetailBodyState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends ReportDetailBodyState {
  final ReportDetailBodyModel reportDetails;

  Loaded({
    required this.reportDetails,
  });

  @override
  List<Object> get props => [reportDetails];
}
