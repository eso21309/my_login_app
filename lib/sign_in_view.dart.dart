import 'package:flutter/material.dart';
import 'package:my_login_app/sign_in_viewmodel.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: SignInViewModel.instance.isSignedIn,
      builder: (context, isSignedIn, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (isSignedIn) {
                  await SignInViewModel.instance.signOut(); // 로그아웃 함수 연결
                } else {
                  await SignInViewModel.instance.signIn(); // 로그인 함수 연결
                }
              },
              child: Text(isSignedIn ? '로그아웃 하기' : '구글로 시작하기'), // 버튼 텍스트 변경
            ),
            if (isSignedIn) ...[
              // 로그인 후 추가 정보 표시
              Text('로그인 성공!'),
            ],
          ],
        );
      },
    );
  }
}
