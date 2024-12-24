import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInViewModel {
  // 1. 싱글톤 패턴 올바르게 정의
  static final SignInViewModel _instance =
      SignInViewModel._privateConstructor();
  static SignInViewModel get instance => _instance;

  // 2. Firebase 및 구글 로그인 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 3. 로그인 상태를 추적하는 ValueNotifier
  final ValueNotifier<bool> isSignedIn = ValueNotifier<bool>(false);

  // 4. private 생성자에서 인증 상태 리스너 초기화
  SignInViewModel._privateConstructor() {
    // Firebase 인증 상태 변화 감지
    _auth.authStateChanges().listen((User? user) {
      isSignedIn.value = user != null;
      print('Auth 상태 변경: ${user?.email ?? "로그아웃"}');
    });
  }

  // 5. 구글 로그인 구현
  Future<void> signIn() async {
    try {
      // 구글 로그인 다이얼로그 표시
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('로그인 취소됨');
        return;
      }

      // 구글 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase 인증 정보 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase 로그인 실행
      await _auth.signInWithCredential(credential);
      print('로그인 성공: ${googleUser.email}');
    } catch (e) {
      print('구글 로그인 오류: $e');
      // 에러 처리는 여기서
    }
  }

  // 6. 로그아웃 구현
  Future<void> signOut() async {
    try {
      // 둘 다 로그아웃 처리
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);

      print('로그아웃 완료');
    } catch (e) {
      print('로그아웃 오류: $e');
      // 에러 처리는 여기서
    }
  }
}
