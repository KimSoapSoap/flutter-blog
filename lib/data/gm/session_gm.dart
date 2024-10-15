import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

//글로벌 모델. 글로벌 데이터 덩어리를 관리
//창고겸 데이터.
class SessionGM {
  int? id;
  String? username;
  String? accessToken;
  bool isLogin; // 초기값 false 넣어주고 null 처리 하지 않는다. 무조건 들어오므로. 나중에 !안 쓰기 위해서

  SessionGM({this.id, this.username, this.accessToken, this.isLogin = false});

  final mContext = navigatorKey.currentContext!;

  Future<void> login(String username, String password) async {
    // 1. 통신 {success: 머시기, status: 미시기, errorMessage:머시기, response: 오브젝트}
    //리턴을 2개 했기 때문에 첫 번째에
    var (body, accessToken) = await UserRepository().login(username, password);

    //통신 잘 되나 확인하기
    Logger().d("세션 창고의 login()메서드 실행됨 ${body}, ${accessToken}");

    // 2. 성공 or 실패 처리
    if (body["success"]) {
      Logger().d("로그인 성공");
      // 성공 처리
      // (1) SessionGM값 변경
      this.id = body["response"]["id"];
      this.username = body["response"]["username"];
      this.accessToken = accessToken;
      this.isLogin = true;

      // (2) 휴대폰 하드 저장
      // 반드시 저장 하고 넘어가기 위해 await 붙임
      // sharedStorage가 있고 securedStorage가 있는데 토큰은 securedStorage에 저장
      await secureStorage.write(key: "accessToken", value: accessToken);

      // (3) dio에 토큰 세팅 -> 매번 토큰 안 꺼내기 위해
      dio.options.headers["Authorization"] =
          accessToken; // Bearer 떼고 받았기 때문에 그냥 보내준다.

      // (4) 화면 이동
      Navigator.pushNamed(mContext, "/post/list");
    } else {
      Logger().d("로그인 실패");
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text('$body["erroMessage"]')));
    }
  }

  Future<void> join() async {}

  Future<void> logout() async {
    // 1. 토큰 삭제
    // accessToken을 메모리, 하드디스크에서 삭제시키는 것이므로 await를 걸어준다.
    // OS에서 하드웨어 레벨까지 내려갔다가 오는 것이므로 시간이 좀 걸린다.
    // 즉 I/O가 발생하는 것은 다 await를 붙여주면 된다.
    await secureStorage.delete(key: "accessToken");

    // 2. 토큰 삭제했으므로 상태를 바꿔주면 된다
    // 내 메모리에서 처리하는 것이므로 await가 필요 없다.
    this.id = null;
    this.username = null;
    this.accessToken = null;
    this.isLogin = false;
    //로그아웃했으므로 로그인 페이지로 보내면서 다 지우고
    Logger().d(
        '로그아웃 실행 => id: $id,  username: $username,  accessToken: $accessToken, isLogin: $isLogin');
    Navigator.popAndPushNamed(mContext, "/login");
  }

  Future<void> autoLogin() async {
    // 1. secureStorage에서 accessToken 꺼내기. 없으면 /login으로 보내기
    String? accessToken = await secureStorage.read(key: "accessToken");

    if (accessToken == null) {
      Navigator.popAndPushNamed(mContext, "/login");
    } else {
      // 2. api 호출
      Map<String, dynamic> body = await UserRepository().autoLogin(accessToken);

      // 3. 정상이면 post/list
      // splash창을 날리고 가야되므로 popAndPush로 보낸다.
      // 안 날리면 계속 스플래쉬 화면이 뒤에 남아 있으므로
      this.id = body["response"]["id"];
      this.username = body["response"]["username"];
      this.accessToken = accessToken;
      this.isLogin = true;

      // 4. 정상이면 /post/list로 이동 (pop and pushNamed)
      Navigator.popAndPushNamed(mContext, "/post/list");
    }
  }
}

final sessionProvider = StateProvider<SessionGM>((ref) {
  return SessionGM();
});
