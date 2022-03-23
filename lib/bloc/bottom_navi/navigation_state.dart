part of 'navigation_cubit.dart';

// bottom navigation bar item
enum NavbarItem { home, map, report, reportList, mypage }

abstract class NavigationState extends Equatable {}

// 네비게이션 바 상태
class Navigation extends NavigationState {
  // 큐빗의 상태를 정의
  Navigation(this.navbarItem, this.index);

  final NavbarItem navbarItem;
  final int index;

  // 상태는 enum에 정의된 NavbarItem 유형과 하단 탐색 모음의 항목 위치에 해당하는 정수 인덱스를 매개변수로 받음.
  @override
  List<Object> get props => [navbarItem, index];
}
