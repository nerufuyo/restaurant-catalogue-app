import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/navigation.dart';

customDialog(BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Coming Soon'),
            content: const Text('This feature is coming soon!'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Okay'),
                onPressed: () => Navigation.back(),
              )
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Coming Soon'),
            content: const Text('This feature is coming soon!'),
            actions: [
              TextButton(
                  onPressed: () => Navigation.back(), child: const Text('Okay'))
            ],
          );
        });
  }
}
