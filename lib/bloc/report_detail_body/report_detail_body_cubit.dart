import 'package:bloc/bloc.dart';
import 'package:comaplain/bloc/report_detail_body/report_detail_body_state.dart';
import '../../repository/report_detail_body_repository.dart';

class ReportDetailBodyCubit extends Cubit<ReportDetailBodyState> {
  final ReportDetailBodyRepository repository;

  // 초기 값
  ReportDetailBodyCubit({required this.repository}) : super(Empty());

  // Report Detail
  reportDetail(int id) async {
    try {
      emit(Loading());

      final resp = await repository.detailReport(id);

      emit(Loaded(reportDetails: resp));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
