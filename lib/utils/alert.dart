import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class Alert {
  static Future<void> alertValidation(message, BuildContext context) async {
    Flushbar(
      message: message,
      icon: const Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.red,
      ),
      margin: const EdgeInsets.all(6.0),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      textDirection: Directionality.of(context),
      borderRadius: BorderRadius.circular(12),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: Colors.red,
    ).show(context);
  }

  static Future<void> successMessage(message, BuildContext context) async {
    Flushbar(
      message: message,
      icon: const Icon(
        Icons.check_circle_outline_rounded,
        size: 28.0,
        color: Colors.green,
      ),
      margin: const EdgeInsets.all(6.0),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      textDirection: Directionality.of(context),
      borderRadius: BorderRadius.circular(12),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: Colors.green,
    ).show(context);
  }
}
