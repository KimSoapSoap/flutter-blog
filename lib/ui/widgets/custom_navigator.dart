import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/gm/session_gm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class CustomNavigation extends ConsumerWidget {
  final scaffoldKey;

  const CustomNavigation(this.scaffoldKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: getDrawerWidth(context),
      height: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  scaffoldKey.currentState!.openEndDrawer();
                  Navigator.pushNamed(context, "/post/write");
                },
                child: const Text(
                  "글쓰기",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () {
                  //로그아웃 누르고 Drawer 페이지 닫아주기. 다른 화면으로 갈 거고 뒤로가기 기록도 지우고 가므로 안 해줘도 된다.
                  //하지만 뒤로가기가 된다면 안 닫고 가면 뒤로가기가 했을 때 뒤로가기 했을 때 drawer창이 열려 있을 것이므로
                  //적절하게 사용하면 된다.
                  scaffoldKey.currentState!.openEndDrawer();
                  //Navigator.popAndPushNamed(context, "/login");

                  //원래는 로그아웃 누르면 위에 네이게이터로 이동시켜줬지만 이제 상태변경으로 관리자를 통해 logout() 실행하고
                  //해당 메서드에 로직을 처리한 뒤 거기서 화면이동 시켜줌.  session_gm.dart의 logout()에 보면
                  // Navigator.popAndPushNamed(mContext, "/login"); 가 존재한다.
                  Logger().d("네비게이션 바에서 로그 아웃 클릭 직전");
                  ref.read(sessionProvider).logout();
                },
                child: const Text(
                  "로그아웃",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
