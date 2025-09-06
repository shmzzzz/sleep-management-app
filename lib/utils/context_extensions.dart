import 'package:flutter/material.dart';

extension ContextSnackBar on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

