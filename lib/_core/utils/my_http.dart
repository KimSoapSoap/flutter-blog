import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//
final baseUrl = "http://192.168.0.99:8080";

//로그인 되면, dio에 jwt 추가하기
//dio.options.headers['Authorization'] = 'Bearer $_accessToken';
final dio = Dio(
  BaseOptions(
    baseUrl: baseUrl, // 내 IP 입력
    contentType: "application/json; charset=utf-8",
    //응답코드가 200이 아니면 다 터지는데 그러면 에러 메시지를 못 받는다.
    //그렇기 때문에 아래의 설정을 해줘야 응답 코드가 200이 아니어도(실패했어도) 서버가 터지지 않고 에러메시지를 받는다.
    //그래야 에러 메시지를 받아서 alert를 띄워줄 수 있을 것이다.
    validateStatus: (status) => true, // 200 이 아니어도 예외 발생안하게 설정
  ),
);

const secureStorage = FlutterSecureStorage();
