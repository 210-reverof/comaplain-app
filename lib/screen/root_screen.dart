import 'package:comaplain/screen/login/login_screen.dart';
import 'package:comaplain/screen/my_page/my_page_screen.dart';
import 'package:comaplain/screen/report_list/report_list_screen.dart';
import 'package:comaplain/screen/map/map_screen.dart';
import 'package:comaplain/screen/report_writing/report_write_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../bloc/bottom_navi/navigation_cubit.dart';
import 'main/main_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? backbuttonpressedTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime!) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // 게시물 작성 페이지로 이동
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReportWriteScreen()));
            },
            child: Image.asset("assets/bottom_report.png") //icon inside button
            ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // BlocBuilder는 큐빗의 현재 상태에 따라 하단 item을 빌드
        bottomNavigationBar: BlocBuilder<NavigationCubit, Navigation>(
          builder: (context, state) {
            return BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 8.0,
              clipBehavior: Clip.antiAlias,
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedFontSize: 13.0,
                selectedItemColor: Colors.green.shade500,
                unselectedFontSize: 10.0,
                // unselectedItemColor: Colors.grey.shade200,
                type: BottomNavigationBarType.fixed,
                currentIndex: state.index,
                items: [
                  BottomNavigationBarItem(
                    icon: new Image.asset('assets/bottom_main_false.png',
                        width: 40, height: 40),
                    activeIcon: new Image.asset('assets/bottom_main_true.png',
                        width: 40, height: 40),
                    label: 'main',
                  ),
                  BottomNavigationBarItem(
                    icon: new Image.asset('assets/bottom_map_false.png',
                        width: 40, height: 40),
                    activeIcon: new Image.asset('assets/bottom_map_true.png',
                        width: 40, height: 40),
                    label: 'map',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: new Image.asset('assets/bottom_list_false.png',
                        width: 40, height: 40),
                    activeIcon: new Image.asset('assets/bottom_list_true.png',
                        width: 40, height: 40),
                    label: 'list',
                  ),
                  BottomNavigationBarItem(
                    icon: new Image.asset('assets/bottom_mypage_false.png',
                        width: 40, height: 40),
                    activeIcon: new Image.asset('assets/bottom_mypage_true.png',
                        width: 40, height: 40),
                    label: 'my page',
                  ),
                ],

                // 눌러진 index에 따라 큐빗의 getNavBarItem 함수를 호출
                onTap: (index) {
                  if (index == 0) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.home);
                  } else if (index == 1) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.map);
                    // } else if (index == 2) {
                    // BlocProvider.of<NavigationCubit>(context)
                    //     .getNavBarItem(NavbarItem.report);
                  } else if (index == 3) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.reportList);
                  } else if (index == 4) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.mypage);
                  }
                },
              ),
            );
          },
        ),
        // 큐빗의 현재 state.navbarItem에 따라 사용자에게 올바른 화면을 표시하기 위해 BlocBuilder를 사용
        body:
            BlocBuilder<NavigationCubit, Navigation>(builder: (context, state) {
          if (state.navbarItem == NavbarItem.home) {
            return MainScreen();
          } else if (state.navbarItem == NavbarItem.map) {
            return MapScreen(CURRENT_USER.latitude as double, CURRENT_USER.longitude as double);
            // } else if (state.navbarItem == NavbarItem.report) {
            // return ReportWriteScreen();
          } else if (state.navbarItem == NavbarItem.reportList) {
            return ReportListScreen();
          } else if (state.navbarItem == NavbarItem.mypage) {
            return MyPageScreen();
          }
          return Container();
        }),
      ),
    );
  }
}
