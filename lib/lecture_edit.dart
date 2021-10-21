import 'package:flutter/material.dart';
import 'package:student_notekeeper/lecture.dart';
import 'package:student_notekeeper/lecture_bloc.dart';
import 'package:student_notekeeper/link_edit.dart';

class LectureNewRoute extends LectureEditRoute {
  LectureNewRoute({Key? key})
      : super(
          lecture: Lecture(""),
          isNew: true,
          key: key,
        );
}

class LectureEditRoute extends StatefulWidget {
  final Lecture lecture;
  final bool isNew;

  const LectureEditRoute({
    Key? key,
    required this.lecture,
    this.isNew = false,
  }) : super(key: key);

  @override
  _LectureEditRouteState createState() => _LectureEditRouteState();
}

class _LectureEditRouteState extends State<LectureEditRoute> {
  @override
  Widget build(BuildContext context) {
    var inputDecoration = const InputDecoration(hintText: "Tutorium address");
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isNew ? "New lecture" : "Edit " + widget.lecture.name),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                BlocProvider.of(context)!.bloc.saveLecture(widget.lecture);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: widget.lecture.name,
              decoration: const InputDecoration(hintText: "Name"),
              onChanged: (text) => widget.lecture.name = text,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: widget.lecture.address,
              decoration: const InputDecoration(hintText: "Address"),
              onChanged: (text) => widget.lecture.address = text,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: widget.lecture.tutoriumAddress,
              decoration: inputDecoration,
              onChanged: (text) => widget.lecture.tutoriumAddress = text,
            ),
            for (MapEntry each in widget.lecture.links.entries)
              LinkEditorWidget(link: each.value),
            TextFormField(
              initialValue: widget.lecture.customNotes,
              decoration: const InputDecoration(hintText: "Custom notes"),
              onChanged: (text) => widget.lecture.customNotes = text,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
