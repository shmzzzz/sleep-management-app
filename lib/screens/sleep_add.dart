import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/widgets/logout_button.dart';

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

  String inputTotal = '';
  String inputSleep = '';
  String inputCore = '';

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      //   // 入力値を含むデータを一覧画面に渡す
      //   final inputData = {
      //     'total': inputTotal,
      //     'sleep': inputSleep,
      //     'core': inputCore,
      //   };
      //   // 一覧画面への遷移
      //   Navigator.of(context).pop(inputData);
      // FireStoreにデータを保存する
      FirebaseFirestore.instance.collection('sleep-data').add({
        'total': inputTotal,
        'sleep': inputSleep,
        'core': inputCore,
        'createdAt': Timestamp.now()
      });
      // 一覧画面への遷移
      Navigator.of(context).pop();
    }
  }

  void _clearText() {
    _totalSleepHourController.text = '';
    _sleepHourController.text = '';
    _coreSleepHourController.text = '';
  }

  @override
  void dispose() {
    _totalSleepHourController.dispose();
    _sleepHourController.dispose();
    _coreSleepHourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠時間追加'),
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
                controller: _totalSleepHourController,
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
