import 'package:flutter/material.dart';

class SleepListScreen extends StatelessWidget {
  const SleepListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠時間一覧'),
      ),
    );
  }
}
