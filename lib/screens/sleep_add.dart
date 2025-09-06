import 'package:cloud_firestore/cloud_firestore.dart';
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
  late bool isAchieved;

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      try {
        final userUid = FirebaseAuth.instance.currentUser!.uid;
        // 目標との比較
        isAchieved = isAchievedByHm(inputTotal, inputGoal);
        // FireStoreにデータを保存する
        const repo = SleepRepository();
        repo.add(userUid, {
          'total': inputTotal,
          'sleep': inputSleep,
          'core': inputCore,
          'goal': inputGoal,
          'isAchieved': isAchieved,
          'createdAt': Timestamp.now(),
        });
        // 一覧画面への遷移
        Navigator.of(context).pop();
      } catch (error) {
        context.showSnackBar(error.toString());
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
              SleepHoursFormTextField(
                controller: _sleepHourController,
                onChanged: (value) {
                  setState(() {
                    inputSleep = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CoreSleepFormTextField(
                controller: _coreSleepHourController,
                onChanged: (value) {
                  setState(() {
                    inputCore = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              GoalSleepFormTextField(
                controller: _goalSleepHourController,
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
