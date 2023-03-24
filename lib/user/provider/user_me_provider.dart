import 'package:acutal/common/const/data.dart';
import 'package:acutal/user/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user_model.dart';
import '../repository/user_me_repository.dart';

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier(
      {required this.authRepository,
      required this.repository,
      required this.storage})
      : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      // state = UserModelLoading();
      // 소스에서 null이 안됨
      state = null;
      return;
    }
    final resp = await repository.getMe();

    state = resp;
  }

  Future<UserModelBase> login ({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();
      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await repository.getMe();

      state = userResp;

      return userResp;
    } catch(e) {
      state = UserModelError(message: "로그인에 실패했습니다.");
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;
    // await storage.delete(key: REFRESH_TOKEN_KEY);
    // await storage.delete(key: ACCESS_TOKEN_KEY);

    // 위처럼 각각 처리 하는 것이 아니라
    // 두개가 동시에 끝날 경우 아래로 내려간다.
    Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
