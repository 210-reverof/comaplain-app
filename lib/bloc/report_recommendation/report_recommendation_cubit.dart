import 'package:bloc/bloc.dart';
import 'package:comaplain/bloc/report_recommendation/report_recommendation_state.dart';
import 'package:comaplain/model/report_recommendation_create_model.dart';
import 'package:comaplain/repository/reprot_recommendation_repository.dart';


class ReportRecommendationCubit extends Cubit<ReportRecommendationState> {
  final ReportRecommendationRepository repository;

  // 초기 값
  ReportRecommendationCubit({required this.repository})
      : super(RecommendationEmpty());

  // Report recommendation GET
  recommendationList() async {
    try {
      emit(RecommendationLoading());
      final resp = await repository.listRecommendation();
      emit(RecommendationLoaded(recommendations: resp));
    } catch (e) {
      emit(RecommendationError(message: e.toString()));
    }
  }

  // Report recommendation create
  recommendationCreate(
      ReportRecommendationCreateModel reportRecommendationCreateModel) async {
    try {
      await repository.createRecommendation(reportRecommendationCreateModel);
    } catch (e) {
      emit(RecommendationError(message: e.toString()));
    }
  }
}
