import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInViewModel {
  SignInViewModel._privateConstructor();

  static final SignInViewModel instance = SignInViewModel._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ValueNotifier<bool> isSignedIn = ValueNotifier(false);

  SignInViewModel() {
    _auth.authStateChanges().listen((User? user) {
      isSignedIn.value = user != null;
      print('로그인 상태 변경: ${isSignedIn.value}'); // 상태 변화 확인
    });
  }

  Future<void> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('로그인 취소됨');
        return; // 로그인 취소 시, 함수 종료
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);
      print('로그인 성공: ${googleUser.email}');
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // 구글 로그아웃
      await _auth.signOut(); // Firebase 로그아웃
      isSignedIn.value = false; // 상태 업데이트
      print('로그아웃 성공');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
