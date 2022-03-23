import 'package:bloc/bloc.dart';
import 'package:comaplain/bloc/solve_write/solve_write_state.dart';
import 'package:comaplain/model/solve_write_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../repository/solve_write_repository copy.dart';


class SolveWriteCubit extends Cubit<SolveWriteState> {
  final SolveWriteRepository repository;

  SolveWriteCubit({required this.repository}) : super(Empty());

  init() async {
    try {
      emit(Loading());      
      emit(Loaded());
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  createSolveText(SolveWriteModel report, List<XFile> pickedImgsm, int id) async {
    try {
      emit(Loading());
      
      // 글 넣기
      await this.repository.createSolveText(report, pickedImgsm, id);

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