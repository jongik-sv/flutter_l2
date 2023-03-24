import 'package:acutal/common/view/splash_screen.dart';
import 'package:acutal/user/model/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routeProvider = Provider<GoRouter>((ref) {
  // watch - 값이 변경 될때 마다 다시 빌드
  // read - 한번만 읽고 값이 변경되도 다시 빌드하지 않음
  final provider = ref.read(authProvider);

  return GoRouter(
    routes: provider.routes,
    initialLocation: SplashScreen.routeName,
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});
