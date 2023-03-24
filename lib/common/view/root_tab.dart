import 'package:acutal/common/const/colors.dart';
import 'package:acutal/common/layout/default_layout.dart';
import 'package:acutal/product/view/product_screen.dart';
import 'package:acutal/user/view/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';

  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(
        length: 4,
        vsync:
            this); // vsync는 TickerProvider를 상속한 클래스만 쓸수 있는데 여기서 SingleTickerProviderStateMixin을 사용했다.
    controller.addListener(tabListener); // 컨트롤러에서 변화가 있으면 tabListener를 실행해 준다.
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩',
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(), // 스크롤이 안되게 함
        controller: controller,
        children: [
          const RestaurantScreen(),
          ProductScreen(),
          Center(
              child: Container(
            child: Text('주문'),
          )),
          Center(
              child: ProfileScreen())
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          // setState(() {
          //   this.index = index;
          // });
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined), label: '음식'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: '주문'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '프로필'),
        ],
      ),
    );
  }
}
