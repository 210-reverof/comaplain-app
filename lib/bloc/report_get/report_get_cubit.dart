import 'package:comaplain/bloc/report_get/report_get_state.dart';
import 'package:bloc/bloc.dart';

import '../../repository/report_get_repository.dart';

class ReportGetCubit extends Cubit<ReportGetState> {
  final ReportGetRepository repository;

  // 초기 값
  ReportGetCubit({required this.repository}) : super(Empty());

  // Report GET
  reportGet() async {
    try {
      emit(Loading());

      final resp = await repository.getReport();

      emit(Loaded(reportGet: resp));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
