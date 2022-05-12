import 'package:flutter/material.dart';

SnackBar snackBar({
  required String message,
  Color color = Colors.green,
}) {
  return SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
  );
}
