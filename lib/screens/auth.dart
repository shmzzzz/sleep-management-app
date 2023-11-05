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
        final userCredentails = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        final userCredentails = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );
      // エラーが発生しているので認証処理は行っていない
      setState(() {
        _isAuthenticating = false;
      });
    }
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
