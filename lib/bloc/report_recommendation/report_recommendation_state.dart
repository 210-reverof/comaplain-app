import 'package:comaplain/model/report_recommendation_list_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReportRecommendationState extends Equatable {}

class RecommendationEmpty extends ReportRecommendationState {
  @override
  List<Object> get props => [];
}

class RecommendationLoading extends ReportRecommendationState {
  @override
  List<Object> get props => [];
}

class RecommendationError extends ReportRecommendationState {
  final String message;

  RecommendationError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class RecommendationLoaded extends ReportRecommendationState {
  final List<ReportRecommendationListModel> recommendations;

  RecommendationLoaded({
    required this.recommendations,
  });

  @override
  List<Object> get props => [recommendations];
}
