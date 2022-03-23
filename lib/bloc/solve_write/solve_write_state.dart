import 'package:equatable/equatable.dart';

abstract class SolveWriteState extends Equatable {}

class Empty extends SolveWriteState {
  @override
  List<Object> get props => [];
}

class Loading extends SolveWriteState {
  @override
  List<Object> get props => [];
}

class Error extends SolveWriteState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends SolveWriteState {
  //final String userJSONString;

  // Loaded({
  //   required this.userJSONString,
  // });

  @override
  List<Object> get props => [];
}