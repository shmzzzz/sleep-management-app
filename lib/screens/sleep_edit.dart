import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/widgets/appbar_component_widget.dart';
import 'package:sleep_management_app/widgets/text_form_fields/core_sleep_form_text_field.dart';
import 'package:sleep_management_app/widgets/text_form_fields/goal_sleep_form_text_field.dart';
import 'package:sleep_management_app/widgets/text_form_fields/sleep_hours_form_text_field.dart';
import 'package:sleep_management_app/widgets/text_form_fields/total_sleep_form_text_field.dart';
import 'package:sleep_management_app/services/sleep_repository.dart';
import 'package:sleep_management_app/utils/context_extensions.dart';
import 'package:sleep_management_app/utils/time_utils.dart';

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
  late TextEditingController goalController;

  @override
  void initState() {
    super.initState();
    // initialDataが外側から受け取った変数なので、widgetを経由して取得する
    totalController = TextEditingController(text: widget.initialData['total']);
    sleepController = TextEditingController(text: widget.initialData['sleep']);
    coreController = TextEditingController(text: widget.initialData['core']);
    goalController = TextEditingController(text: widget.initialData['goal']);
  }

  @override
  void dispose() {
    totalController.dispose();
    sleepController.dispose();
    coreController.dispose();
    goalController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      try {
        final userUid = FirebaseAuth.instance.currentUser!.uid;
        final achieved =
            isAchievedByHm(totalController.text, goalController.text);
        const repo = SleepRepository();
        repo.update(userUid, widget.documentId, {
          'total': totalController.text,
          'sleep': sleepController.text,
          'core': coreController.text,
          'goal': goalController.text,
          'isAchieved': achieved,
        });
        // 一覧画面への遷移（新しい達成状態を返す）
        Navigator.of(context).pop(achieved);
      } catch (error) {
        context.showSnackBar(error.toString());
      }
    }
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
              TotalSleepFormTextField(controller: totalController),
              const SizedBox(
                height: 16,
              ),
              SleepHoursFormTextField(controller: sleepController),
              const SizedBox(
                height: 16,
              ),
              CoreSleepFormTextField(controller: coreController),
              const SizedBox(
                height: 16,
              ),
              GoalSleepFormTextField(controller: goalController),
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
