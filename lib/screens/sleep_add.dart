import 'package:flutter/material.dart';

class SleepAddScreen extends StatefulWidget {
  const SleepAddScreen({super.key});

  @override
  State<SleepAddScreen> createState() => _SleepAddScreenState();
}

class _SleepAddScreenState extends State<SleepAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠時間追加画面'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
