import 'package:comaplain/bloc/user_report_list/user_report_list_state.dart';
import 'package:bloc/bloc.dart';

import '../../repository/user_report_list_repository.dart';

class UserReportListCubit extends Cubit<UserReportListState> {
  final UserReportListRepository repository;

  // 초기 값
  UserReportListCubit({required this.repository}) : super(Empty());

  // Report 보기
  userReportList(String uid) async {
    try {
      emit(Loading());

      final resp = await repository.listReportUser(uid);

      emit(Loaded(userReports: resp));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
