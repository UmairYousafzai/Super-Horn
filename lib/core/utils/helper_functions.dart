import 'package:flutter/material.dart';
import 'package:superhorn/core/theme/colors.dart';

showSnackBar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: AColors.primaryColor,
        content: Text(
          text,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        )),
  );
}
