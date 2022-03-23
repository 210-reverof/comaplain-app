import 'package:equatable/equatable.dart';

abstract class ReportUpdateState extends Equatable {}

class Empty extends ReportUpdateState {
  @override
  List<Object> get props => [];
}

class Loading extends ReportUpdateState {
  @override
  List<Object> get props => [];
}

class Error extends ReportUpdateState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends ReportUpdateState {
  //final String userJSONString;

  // Loaded({
  //   required this.userJSONString,
  // });

  @override
  List<Object> get props => [];
}