import 'package:acutal/common/component/custom_text_form_field.dart';
import 'package:acutal/common/view/splash_screen.dart';
import 'package:acutal/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/layout/default_layout.dart';

void main() {
  runApp(ProviderScope(child: const _App()));
}

class _App extends StatelessWidget {
  const _App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
