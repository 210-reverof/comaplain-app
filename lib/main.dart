import 'package:comaplain/bloc/main_report/main_report_cubit.dart';
import 'package:comaplain/bloc/report_detail_body/report_detail_body_cubit.dart';
import 'package:comaplain/bloc/report_get/report_get_cubit.dart';
import 'package:comaplain/bloc/report_recommendation/report_recommendation_cubit.dart';
import 'package:comaplain/bloc/report_update/report_update_cubit.dart';
import 'package:comaplain/bloc/report_write/report_write_cubit.dart';
import 'package:comaplain/bloc/user/user_cubit.dart';
import 'package:comaplain/bloc/user_report_list/user_report_list_cubit.dart';
import 'package:comaplain/repository/main_report_repository.dart';
import 'package:comaplain/repository/report_detail_comment_repository.dart';
import 'package:comaplain/repository/report_detail_image_repository.dart';
import 'package:comaplain/repository/report_detail_body_repository.dart';
import 'package:comaplain/repository/report_get_repository.dart';
import 'package:comaplain/repository/report_list_repository.dart';
import 'package:comaplain/repository/report_update_repository.dart';
import 'package:comaplain/repository/report_write_repository.dart';
import 'package:comaplain/repository/reprot_recommendation_repository.dart';
import 'package:comaplain/repository/solve_write_repository%20copy.dart';
import 'package:comaplain/repository/user_report_list_repository.dart';
import 'package:comaplain/repository/user_repository.dart';
import 'package:comaplain/screen/login/login_screen.dart';
import 'package:comaplain/screen/my_page/user_report_list_screen.dart';
import 'package:comaplain/screen/report_detail/report_detail_screen.dart';
import 'package:comaplain/screen/report_detail/report_image.screen.dart';
import 'package:comaplain/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/bottom_navi/navigation_cubit.dart';
import 'bloc/report_detail_comment/report_detail_comment_cubit.dart';
import 'bloc/report_detail_image/report_detail_image_cubit.dart';
import 'bloc/report_list/report_list_cubit.dart';
import 'bloc/solve_write/solve_write_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider<ReportListCubit>(
            create: (context) =>
                ReportListCubit(repository: ReportListRepository())),
        BlocProvider<ReportDetailCommentCubit>(
            create: (context) => ReportDetailCommentCubit(
                repository: ReportDetailCommentRepository())),
        BlocProvider<ReportDetailBodyCubit>(
            create: (context) => ReportDetailBodyCubit(
                repository: ReportDetailBodyRepository())),
        BlocProvider<ReportDetailImageCubit>(
            create: (context) => ReportDetailImageCubit(
                repository: ReportDetailImageRepository())),
        BlocProvider<ReportRecommendationCubit>(
            create: (context) => ReportRecommendationCubit(
                repository: ReportRecommendationRepository())),
        BlocProvider<UserReportListCubit>(
            create: (context) =>
                UserReportListCubit(repository: UserReportListRepository())),
        BlocProvider<ReportGetCubit>(
            create: (context) =>
                ReportGetCubit(repository: ReportGetRepository())),
        BlocProvider(
            create: (_) => MainReportCubit(repository: MainReportRepository())),
        BlocProvider(create: (_) => UserCubit(repository: UserRepository())),
        BlocProvider(
            create: (_) =>
                ReportWriteCubit(repository: ReportWriteRepository())),
        BlocProvider(
            create: (_) => SolveWriteCubit(repository: SolveWriteRepository())),
        BlocProvider(
            create: (_) => ReportUpdateCubit(repository: ReportUpdateRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: "/",
        routes: {
          "/": (context) => LogInScreen(),
          "/RootScreen": (context) => RootScreen(),
          "/ReportImageScreen": (context) => ReportImageScreen(),
          "/ReportDetailScreen": (context) => ReportDetailScreen(),
          "/UserReportListScreen": (context) => UserReportListScreen(),
        },
      ),
    );
  }
}
