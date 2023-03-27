import 'package:acutal/common/view/root_tab.dart';
import 'package:acutal/common/view/splash_screen.dart';
import 'package:acutal/restaurant/view/restaurant_detail_screen.dart';
import 'package:acutal/user/model/user_model.dart';
import 'package:acutal/user/provider/user_me_provider.dart';
import 'package:acutal/user/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';



final authProvider = ChangeNotifierProvider((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (context, state) => RootTab(),
            routes: [
              GoRoute(
                path: 'restaurant/:rid',
                name: RestaurantDetailScreen.routeName,
                builder: (context, state) =>
                    RestaurantDetailScreen(id: state.params['rid']!),
              )
            ]),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (context, state) => LoginScreen(),
        ),
      ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // SplashScreen
  /// 앱을 처음 시작했을때
  /// 토큰이 존재하는지 확인
  /// 로그인 스크린으로 갈지, 홈스크린으로 갈지 확인하는 과정 필요
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final logginIn = state.location == '/login';

    /// 유저 정보가 없는데
    /// 로그인 중이면 그대로 로그인 페이지에 두고
    /// 만약 로그인 중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return logginIn ? null : '/login';
    }

    /// user가 null이 아님

    /// UserModel
    /// 사용자 정보가 있는 상태면
    /// 로그인 중이거나 현재 위치가 SplashScreen이면 홈으로 이동
    if (user is UserModel) {
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    /// userModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
