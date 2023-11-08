import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  // ログイン状態を管理するフラグ
  var _isLogin = true;
  // 認証処理の通信状態を管理するフラグ
  var _isAuthenticating = false;
  // 入力されたメールアドレス
  var _enteredEmail = '';
  // 入力されたパスワード
  var _enteredPassword = '';

  // ログイン処理を行うメソッド
  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    // currentStateがvalidate出ない場合は処理を行わない
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      // このブロックに入る=認証処理を行う必要があるのでtrue
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        // ログインしている場合の処理
        await _login();
      } else {
        await _createUserAndLogin();
      }
    } on FirebaseAuthException catch (error) {
      // エラーハンドリングは以下を参考にすると良いかも
      // https://qiita.com/edasan/items/ae0c04065c9d12b2e90e
      if (error.code == 'email-already-in-use') {
        _showSnackBar('このメールアドレスはすでに使用されています。');
      } else if (error.code == 'invalid-email') {
        _showSnackBar('メールアドレスが有効ではありません。');
      } else if (error.code == 'invalid_login_credentials') {
        _showSnackBar('メールアドレスまたはパスワードが誤っています。');
      } else if (error.code == 'too-many-requests') {
        _showSnackBar('時間をおいてから実行してください。');
      } else {
        _showSnackBar(error.message ?? '認証に失敗しました。');
      }
      // エラーが発生しているので認証処理は行っていない
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future<void> _login() async {
    await _firebase.signInWithEmailAndPassword(
      email: _enteredEmail,
      password: _enteredPassword,
    );
  }

  Future<void> _createUserAndLogin() async {
    final userCredentails = await _firebase.createUserWithEmailAndPassword(
      email: _enteredEmail,
      password: _enteredPassword,
    );
    // Firestoreへ登録する
    await FirebaseFirestore.instance
        .collection('users') // コレクションID(テーブル名的な)
        .doc(userCredentails
            .user!.uid) // ドキュメントID << usersコレクション内のドキュメント(ユニークなものだったら何でも良い？)
        .set({
      // データを設定する
      'username': 'to be done...',
      'email': _enteredEmail,
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('メールアドレス'),
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return 'メールアドレスを入力してください。';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredEmail = newValue!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('パスワード'),
                  prefixIcon: Icon(Icons.key),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'パスワードを6文字以上で入力してください。';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredPassword = newValue!;
                },
              ),
              const SizedBox(height: 16),
              // 認証処理中はローディングスピナーを表示させる
              if (_isAuthenticating) const CircularProgressIndicator(),
              if (!_isAuthenticating)
                // 認証処理中でない場合はボタンを表示させる
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Text(_isLogin ? 'ログイン' : '新規作成'),
                ),
              // 認証処理中でない場合はボタンを表示させる
              if (!_isAuthenticating)
                TextButton(
                  onPressed: () {
                    // このボタンをタップすると_isLoginの値が変わるようにする
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin ? 'アカウント新規作成' : 'ログイン'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
