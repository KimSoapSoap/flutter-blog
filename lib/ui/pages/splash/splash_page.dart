import 'package:flutter/material.dart';
import 'package:flutter_blog/data/gm/session_gm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //처음에 스플래쉬 화면에서 무거운 연산 다 넣고 오토 로그인해서 입장시켜 준다.
    ref.read(sessionProvider).autoLogin();


    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
