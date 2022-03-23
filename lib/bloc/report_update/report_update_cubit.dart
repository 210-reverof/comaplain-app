import 'package:bloc/bloc.dart';
import 'package:comaplain/bloc/report_update/report_update_state.dart';
import 'package:comaplain/model/report_update_model.dart';
import 'package:comaplain/repository/report_update_repository.dart';
import 'package:image_picker/image_picker.dart';


class ReportUpdateCubit extends Cubit<ReportUpdateState> {
  final ReportUpdateRepository repository;

  ReportUpdateCubit({required this.repository}) : super(Empty());

  init() async {
    try {
      emit(Loading());
      emit(Loaded());
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  createReportText(int id, int solved, ReportUpdateModel report, List<XFile> pickedImgs) async {
    try {
      emit(Loading());

      // 글 넣기
      await this.repository.updateReport(id, solved, report, pickedImgs);

      emit(Loaded());
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}