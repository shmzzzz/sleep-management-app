import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleep_management_app/widgets/appbar_component_widget.dart';
import 'package:sleep_management_app/widgets/total_sleep_form_text_field.dart';

class SleepAddScreen extends StatefulWidget {
  const SleepAddScreen({super.key});

  @override
  State<SleepAddScreen> createState() => _SleepAddScreenState();
}

class _SleepAddScreenState extends State<SleepAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _totalSleepHourController = TextEditingController();
  final _sleepHourController = TextEditingController();
  final _coreSleepHourController = TextEditingController();
  final _goalSleepHourController = TextEditingController();

  String inputTotal = '';
  String inputSleep = '';
  String inputCore = '';
  String inputGoal = '';

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
        FirebaseFirestore.instance.collection(userPath).add({
          'total': inputTotal,
          'sleep': inputSleep,
          'core': inputCore,
          'goal': inputGoal,
          'createdAt': Timestamp.now()
        });
        // DateTimeに変換する
        DateTime totalDateTime = DateFormat('HH:mm').parse(inputTotal);
        DateTime goalDateTime = DateFormat('HH:mm').parse(inputGoal);
        // 目標との比較
        bool isAchieved = totalDateTime.isAfter(goalDateTime) ||
            totalDateTime.isAtSameMomentAs(goalDateTime);
        // 一覧画面への遷移
        Navigator.of(context).pop(isAchieved);
      } catch (error) {
        _showSnackBar(error.toString());
      }
    }
  }

  void _clearText() {
    _totalSleepHourController.text = '';
    _sleepHourController.text = '';
    _coreSleepHourController.text = '';
    _goalSleepHourController.text = '';
  }

  @override
  void dispose() {
    _totalSleepHourController.dispose();
    _sleepHourController.dispose();
    _coreSleepHourController.dispose();
    _goalSleepHourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponentWidget(
        title: FirebaseAuth.instance.currentUser!.email!,
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
              TotalSleepFormTextField(
                controller: _totalSleepHourController,
                onChanged: (value) {
                  setState(() {
                    inputTotal = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _sleepHourController,
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
                onChanged: (value) {
                  setState(() {
                    inputSleep = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _coreSleepHourController,
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
                onChanged: (value) {
                  setState(() {
                    inputCore = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _goalSleepHourController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('目標睡眠時間'),
                  prefixIcon: Icon(Icons.checklist_outlined),
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
                onChanged: (value) {
                  setState(() {
                    inputGoal = value;
                  });
                },
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('追加'),
              ),
              TextButton(
                onPressed: _clearText,
                child: const Text('クリア'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
