import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:student_notekeeper/models/lecture.dart';

class QrLectureDialog extends StatelessWidget {
  final Lecture lecture;
  const QrLectureDialog({Key? key, required this.lecture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 250,
        height: 350,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: QrImage(
                  data: jsonEncode(lecture.toMap()),
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
            ),
            const Flexible(
              child: Text(
                "To copy this lecture by QR, go to 'New lecture' creation page and tap on the QR scanner button",
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
