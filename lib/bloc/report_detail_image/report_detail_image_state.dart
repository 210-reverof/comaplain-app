import 'package:equatable/equatable.dart';
import '../../model/report_detail_image_model.dart';

abstract class ReportDetailImageState extends Equatable {}

class Empty extends ReportDetailImageState {
  @override
  List<Object> get props => [];
}

class Loading extends ReportDetailImageState {
  @override
  List<Object> get props => [];
}

class Error extends ReportDetailImageState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends ReportDetailImageState {
  final List<ReportDetailImageModel> images;

  Loaded({
    required this.images,
  });

  @override
  List<Object> get props => [images];
}
