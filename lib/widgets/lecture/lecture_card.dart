import 'package:flutter/material.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/routes/lectures/lecture_view.dart';

class LectureCard extends StatefulWidget {
  final Lecture lecture;

  const LectureCard({Key? key, required this.lecture}) : super(key: key);

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () {
        Navigator.push(context, LectureViewPage.route(lecture: widget.lecture));
      },
      child: ListTile(
        title: Text(
          widget.lecture.name,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    ));
  }
}
