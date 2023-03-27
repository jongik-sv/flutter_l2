import 'package:acutal/common/const/colors.dart';
import 'package:acutal/common/layout/default_layout.dart';
import 'package:acutal/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/component/custom_text_form_field.dart';
import '../provider/user_me_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = 'test@codefactory.ai';
  String password = 'testtest';

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(userMeProvider);
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력하세요.',
                  errorText: null,
                  initValue: 'test@codefactory.ai',
                  onChanged: (value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: '비밀번호를 입력하세요.',
                  obscureText: true,
                  errorText: null,
                  initValue: 'testtest',
                  onChanged: (value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: state is UserModelLoading
                      ? null
                      : () async {
                          ref
                              .read(userMeProvider.notifier)
                              .login(username: username, password: password);
                          // //final rawString = 'test@codefactory.ai:testtest';
                          // final rawString = '$username:$password';
                          //
                          // String token = DataUtils.plainToBase64(rawString);
                          // // Codec<String, String> string2Base64 = utf8.fuse(base64);
                          // //
                          // // String token = string2Base64.encode(rawString);
                          //
                          // final resp = await dio.post(
                          //   'http://$ip/auth/login',
                          //   options: Options(headers: {'authorization': 'Basic $token'}),
                          // );
                          //
                          // final refreshToken = resp.data['refreshToken'];
                          // final accessToken = resp.data['accessToken'];
                          //
                          // final storage = ref.read(secureStorageProvider);
                          // await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                          // await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
                          //
                          // Navigator.of(context).push(MaterialPageRoute(builder: (_) => RootTab()));
                        },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
                  child: Text('로그인'),
                ),
                TextButton(
                  onPressed: () async {},
                  style:
                      ElevatedButton.styleFrom(foregroundColor: PRIMARY_COLOR),
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다.',
      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요.\n 오늘도 성공적인 주문이 되길:)',
      style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR),
    );
  }
}
