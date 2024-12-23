import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar(
    BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
      backgroundColor: Colors.green,
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar(
    BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
      backgroundColor: Colors.red,
    ),
  );
}
