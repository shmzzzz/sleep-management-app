import 'package:flutter/material.dart';

class SleepAddScreen extends StatefulWidget {
  const SleepAddScreen({super.key});

  @override
  State<SleepAddScreen> createState() => _SleepAddScreenState();
}

class _SleepAddScreenState extends State<SleepAddScreen> {
  final _totalSleepHourController = TextEditingController();
  final _sleepHourController = TextEditingController();
  final _coreSleepHourController = TextEditingController();

  void _clearText() {
    _totalSleepHourController.text = '';
    _sleepHourController.text = '';
    _coreSleepHourController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠時間追加'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Form(
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
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: () {
                  print(_totalSleepHourController.text);
                  print(_sleepHourController.text);
                  print(_coreSleepHourController.text);

                  // 一覧画面への遷移
                  Navigator.of(context).pop();
                },
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
