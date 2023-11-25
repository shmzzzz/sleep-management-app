import 'package:flutter/material.dart';

/// 目標睡眠時間のウィジェット
class GoalSleepFormTextField extends StatelessWidget {
  const GoalSleepFormTextField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text('目標睡眠時間'),
        prefixIcon: Icon(Icons.checklist_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '入力してください。';
        } else if (!RegExp(r'^[0-2][0-9]:[0-5][0-9]$').hasMatch(value)) {
          return '正しい時間形式(hh:mm)で入力してください。';
        }
        return null;
      },
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }
}
