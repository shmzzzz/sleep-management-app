import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/widgets/logout_button.dart';

class SleepEditScreen extends StatefulWidget {
  const SleepEditScreen({
    super.key,
    required this.initialData,
    required this.documentId,
  });

  final Map<String, dynamic> initialData;
  final String documentId;

  @override
  State<SleepEditScreen> createState() => _SleepEditScreenState();
}

class _SleepEditScreenState extends State<SleepEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController totalController;
  late TextEditingController sleepController;
  late TextEditingController coreController;

  @override
  void initState() {
    super.initState();
    totalController = TextEditingController(text: widget.initialData['total']);
    sleepController = TextEditingController(text: widget.initialData['sleep']);
    coreController = TextEditingController(text: widget.initialData['core']);
  }

  @override
  void dispose() {
    totalController.dispose();
    sleepController.dispose();
    coreController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      try {
        // ユーザーのUIDを取得
        String userUid = FirebaseAuth.instance.currentUser!.uid;
        // ユーザーごとにデータを保存するパスを構築
        String userPath = 'users/$userUid/data';
        // FireStoreにデータを保存する
        // ユーザーごとに出し分けたいため、collectionに渡すpathを変更する
        FirebaseFirestore.instance
            .collection(userPath)
            .doc(widget.documentId)
            // 更新なのでupdate
            .update({
          'total': totalController.text,
          'sleep': sleepController.text,
          'core': coreController.text,
        });
        // 一覧画面への遷移
        Navigator.of(context).pop();
      } catch (error) {
        _showSnackBar(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${FirebaseAuth.instance.currentUser!.email}'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: const [
          LogoutButton(),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 32,
              ),
              TextFormField(
                controller: totalController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('睡眠時間(合計)'),
                  prefixIcon: Icon(Icons.timelapse),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '入力してください。';
                  } else if (!RegExp(r'^[0-2][0-9]:[0-5][0-9]$')
                      .hasMatch(value)) {
                    return '正しい時間形式(hh:mm)で入力してください。';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: sleepController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('睡眠時間'),
                  prefixIcon: Icon(Icons.av_timer),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '入力してください。';
                  } else if (!RegExp(
                          r'^[0-2][0-9]:[0-9]{2}-[0-2][0-9]:[0-5][0-9]$')
                      .hasMatch(value)) {
                    return '正しい時間形式(hh:mm-hh:mm)で入力してください。';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: coreController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('深い睡眠'),
                  prefixIcon: Icon(Icons.bedtime_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '入力してください。';
                  } else if (!RegExp(r'^[0-2][0-9]:[0-5][0-9]$')
                      .hasMatch(value)) {
                    return '正しい時間形式(hh:mm)で入力してください。';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('更新'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}