import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<Navigation> {
  // 초기 상태를 NavbarItem.home으로 설정하고 인덱스를 0으로 설정
  NavigationCubit() : super(Navigation(NavbarItem.home, 0));

  // 큐빗의 상태를 관리하는 기본 수단이 될 getNavBarItem이라는 함수를 정의
  // 사용자가 탭한 하단 item의 요소에 따라 큐빗에 새 상태를 내보냄.
  // emit 함수를 사용하여 상태 변경
  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.home:
        emit(Navigation(NavbarItem.home, 0));
        break;
      case NavbarItem.map:
        emit(Navigation(NavbarItem.map, 1));
        break;
      case NavbarItem.report:
        emit(Navigation(NavbarItem.report, 2));
        break;
      case NavbarItem.reportList:
        emit(Navigation(NavbarItem.reportList, 3));
        break;
      case NavbarItem.mypage:
        emit(Navigation(NavbarItem.mypage, 4));
    }
  }
}
