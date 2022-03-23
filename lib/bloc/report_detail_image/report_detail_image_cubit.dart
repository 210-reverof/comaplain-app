import 'package:bloc/bloc.dart';
import 'package:comaplain/bloc/report_detail_image/report_detail_image_state.dart';
import '../../repository/report_detail_image_repository.dart';

class ReportDetailImageCubit extends Cubit<ReportDetailImageState> {
  final ReportDetailImageRepository repository;

  // 초기 값
  ReportDetailImageCubit({required this.repository}) : super(Empty());

  // report detail image
  reportDetailImage(int id, String solved) async {
    try {
      emit(Loading());

      final resp = await repository.detailImageReport(id, solved);

      emit(Loaded(images: resp));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
