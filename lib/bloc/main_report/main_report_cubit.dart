import 'package:comaplain/model/main_report_model.dart';
import 'package:comaplain/bloc/main_report/main_report_state.dart';
import 'package:comaplain/repository/main_report_repository.dart';
import 'package:bloc/bloc.dart';

class MainReportCubit extends Cubit<MainReportState> {
  final MainReportRepository repository;

  MainReportCubit({required this.repository}) : super(Empty());

  mainReportList(double lat, double lng) async {
    try {
      emit(Loading());

      final res = await repository.mainReportList(lat, lng);

      emit(Loaded(mainReports: res));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

}
