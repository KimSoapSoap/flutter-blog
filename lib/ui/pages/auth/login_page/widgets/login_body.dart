import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/gm/session_gm.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_logo.dart';
import 'package:flutter_blog/ui/widgets/custom_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

//여기서 상태를 바꿀 것이니까 Consumer로 바꿔야 한다.
class LoginBody extends ConsumerWidget {
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const CustomLogo("Blog"),
          CustomAuthTextFormField(
            text: "Username",
            controller: _username,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Password",
            obscureText: true,
            controller: _password,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "로그인",
            click: () {
              //d는 debbeger라는 의미. 디버깅을 하기 위함
              Logger().d("로그인 버튼 클릭됨 ${_username.text}, ${_password.text}");
              ref
                  .read(sessionProvider)
                  .login(_username.text.trim(), _password.text.trim());
              //Navigator.popAndPushNamed(context, "/post/list");
            },
          ),
          CustomTextButton(
            text: "회원가입 페이지로 이동",
            click: () {
              Navigator.pushNamed(context, "/join");
            },
          ),
        ],
      ),
    );
  }
}
