import 'package:comaplain/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

class Empty extends UserState {
  @override
  List<Object> get props => [];
}

class Loading extends UserState {
  @override
  List<Object> get props => [];
}

class Error extends UserState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends UserState {
  final String userJSONString;

  Loaded({
    required this.userJSONString,
  });

  @override
  List<Object> get props => [userJSONString];
}