import 'package:firebase_auth/firebase_auth.dart';

String mapFirebaseAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'email-already-in-use':
      return 'このメールアドレスはすでに使用されています。';
    case 'invalid-email':
      return 'メールアドレスが有効ではありません。';
    case 'invalid-login-credentials':
    case 'wrong-password':
    case 'user-not-found':
      return 'メールアドレスまたはパスワードが誤っています。';
    case 'too-many-requests':
      return '時間をおいてから実行してください。';
    default:
      return error.message ?? '認証に失敗しました。';
  }
}

