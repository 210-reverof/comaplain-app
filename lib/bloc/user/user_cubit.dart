import 'package:bloc/bloc.dart';
import 'package:comaplain/bloc/user/user_state.dart';
import 'package:comaplain/model/user_model.dart';
import 'package:comaplain/repository/user_repository.dart'; 

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(Empty());

  init() async {
    try {
      emit(Loading());      
      emit(Loaded(userJSONString: "ready"));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  addUser(UserModel user) async {
    try {
      emit(Loading());
      
      final userJSONString = await this.repository.addUser(user);

      emit(Loaded(userJSONString: userJSONString));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  hasUser(String uid) async {
    try {
      emit(Loading());
      
      final userJSONString = await this.repository.hasUser(uid);
      
      emit(Loaded(userJSONString: userJSONString));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  
}


