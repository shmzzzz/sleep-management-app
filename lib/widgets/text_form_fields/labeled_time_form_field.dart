import 'package:flutter/material.dart';
import 'package:sleep_management_app/utils/time_utils.dart';

enum TimeFieldKind { hm, hmRange }

class LabeledTimeFormField extends StatelessWidget {
  const LabeledTimeFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.kind = TimeFieldKind.hm,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TimeFieldKind kind;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final regExp = kind == TimeFieldKind.hm ? reHm : reHmRange;
    final formatHint = kind == TimeFieldKind.hm ? 'hh:mm' : 'hh:mm-hh:mm';
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(label),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '入力してください。';
        } else if (!regExp.hasMatch(value)) {
          return '正しい時間形式($formatHint)で入力してください。';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}

