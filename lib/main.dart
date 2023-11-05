import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/screens/auth.dart';
import 'package:sleep_management_app/screens/sleep_list.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Management App',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 14, 218, 208),
        ),
      ),
      home: StreamBuilder(
        // 認証状態の変更を取得する
        // ①リスナーの登録直後 ②ユーザーがログインした時 ③現在のユーザーがログアウトした時
        // https://firebase.google.com/docs/auth/flutter/start?hl=ja#authstatechanges
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // snapshotがnullでない=ログイン済みの状態
            // 一覧画面へ遷移する
            return const SleepListScreen();
          }
          // snapshotがnull=未ログイン状態
          // 認証画面へ遷移する
          return const AuthScreen();
        },
      ),
    );
  }
}
