import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';

class UserRepository {
  //repository에는 정확한 이름이 들어가야 한다.

  //원래는 메서드가 verify라는 이름이었다. 로그인이랑 같이 있을 때 안 헷갈리게 잠시 바꿈
  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    final response = await dio.post(
      "/auto/login",
      options: Options(headers: {"Authorization": "Bearer $accessToken"}),
    );
    //try catch를 쓰지 않는 이유는 정해둔 error 메시지를 전달해주기 위해.

    //정상이 아닌 것만 처리
    if (response.statusCode != 200) {}

    Map<String, dynamic> body = response.data;
    //세션 정보 동기화 해주려고 리턴 해준다.
    return body;
  }

  //2개를 리턴하는 구조분해 리턴
  Future<(Map<String, dynamic>, String)> login(
      String username, String password) async {
    final response = await dio
        .post("/login", data: {"username": username, "password": password});

    //에러가 뜨는 이유는 header에 정보가 2개일 경우도 있기 때문에 리스트 타입이기 때문에 거기서 index로 꺼낸다.
    String accessToken = response.headers["Authorization"]![0];

    //만약 앱이라서 브라우저가 아니기 때문에 웹에서 처럼 해보려면 직접 쿠키를 주고 받아야 한다.
    //즉 아래 이 3줄의 코드는 웹에서 쿠키를 사용하는 방법을 사용해보는 것.
    /*
      List<String> cookies = response.headers["Set-Cooke"]!;
      String JSessionId = cookies.where((element) => element.contains("JSessionId")).first;
      dio.options.headers["cookie"] = dio.options.headers["cookie"] + ";JsessionId=$JSessionId";
      */

    //try catch를 쓰지 않는 이유는 정해둔 error 메시지를 전달해주기 위해.

    Map<String, dynamic> body = response.data;
    //세션 정보 동기화 해주려고 리턴 해준다.
    return (body, accessToken);
  }
}
