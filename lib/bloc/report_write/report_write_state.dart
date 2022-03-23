import 'package:equatable/equatable.dart';

abstract class ReportWriteState extends Equatable {}

class Empty extends ReportWriteState {
  @override
  List<Object> get props => [];
}

class Loading extends ReportWriteState {
  @override
  List<Object> get props => [];
}

class Error extends ReportWriteState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends ReportWriteState {
  //final String userJSONString;

  // Loaded({
  //   required this.userJSONString,
  // });

  @override
  List<Object> get props => [];
}