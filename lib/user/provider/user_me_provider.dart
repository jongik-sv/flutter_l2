import 'package:acutal/common/const/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user_model.dart';
import '../repository/user_me_repository.dart';

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final UserMeRepository repository;
  final FlutterSecureStorage storage;
  UserMeStateNotifier({required this.repository, required this.storage}) : super(UserModelLoading()) {
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
}
