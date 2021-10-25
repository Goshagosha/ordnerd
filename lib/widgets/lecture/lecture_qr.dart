import 'package:flutter/material.dart';
import 'package:student_notekeeper/models/lecture.dart';

class QrLectureDialog extends StatelessWidget {
  final Lecture lecture;
  const QrLectureDialog({Key? key, required this.lecture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        // content: Text(lecture.toJson()),
        // content: SizedBox(
        //   width: 200,
        //   height: 200,
        //   child: QrImage(
        //     data: lecture.toJson(),
        //     version: QrVersions.auto,
        //     size: 300,
        //   ),
        // ),
        );
  }
}
