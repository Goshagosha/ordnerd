import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({Key? key, this.okayButtonTitle}) : super(key: key);
  final String? okayButtonTitle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(okayButtonTitle ?? "Proceed"))
      ],
    );
  }
}
