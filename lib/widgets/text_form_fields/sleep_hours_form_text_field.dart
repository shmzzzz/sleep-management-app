import 'package:flutter/material.dart';
import 'package:sleep_management_app/widgets/text_form_fields/labeled_time_form_field.dart';

/// 睡眠時間のウィジェット
class SleepHoursFormTextField extends StatelessWidget {
  const SleepHoursFormTextField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return LabeledTimeFormField(
      controller: controller,
      label: '睡眠時間',
      icon: Icons.av_timer,
      kind: TimeFieldKind.hmRange,
      onChanged: onChanged,
    );
  }
}
