import 'package:comaplain/bloc/report_list/report_list_state.dart';
import 'package:comaplain/repository/report_list_repository.dart';
import 'package:bloc/bloc.dart';

class ReportListCubit extends Cubit<ReportListState> {
  final ReportListRepository repository;

  // 초기 값
  ReportListCubit({required this.repository}) : super(Empty());

  // Report 보기
   reportList(String state, num x, num y) async {
    try {
      emit(Loading());

      final resp = await repository.listReport(state, x, y);

      emit(Loaded(reports: resp));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  // Report 삭제
  reportDelete(int id) async {
    try {
      await repository.deleteReport(id);
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
