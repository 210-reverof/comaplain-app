import 'package:bloc/bloc.dart';
import 'package:comaplain/bloc/report_write/report_write_state.dart';
import 'package:comaplain/model/report_write_model.dart';
import 'package:comaplain/repository/report_write_repository.dart';
import 'package:image_picker/image_picker.dart';


class ReportWriteCubit extends Cubit<ReportWriteState> {
  final ReportWriteRepository repository;

  ReportWriteCubit({required this.repository}) : super(Empty());

  init() async {
    try {
      emit(Loading());      
      emit(Loaded());
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  createReportText(ReportWriteModel report, List<XFile> pickedImgs) async {
    try {
      emit(Loading());
      
      // 글 넣기
      await this.repository.createReportText(report, pickedImgs);

      emit(Loaded());
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  // createReportImage(ReportWriteModel user) async {
  //   try {
  //     emit(Loading());
      
  //     // 이미지 넣기
  //     await this.repository.createReportText(user);

  //     emit(Loaded());
  //   } catch (e) {
  //     emit(Error(message: e.toString()));
  //   }
  // }
}