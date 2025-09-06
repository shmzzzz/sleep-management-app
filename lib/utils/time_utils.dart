import 'package:intl/intl.dart';

final RegExp reHm = RegExp(r'^[0-2][0-9]:[0-5][0-9]$');
final RegExp reHmRange =
    RegExp(r'^[0-2][0-9]:[0-5][0-9]-[0-2][0-9]:[0-5][0-9]$');

DateTime parseHm(String value) {
  return DateFormat('HH:mm').parse(value);
}

bool isAchievedByHm(String total, String goal) {
  final totalDt = parseHm(total);
  final goalDt = parseHm(goal);
  return !totalDt.isBefore(goalDt);
}

