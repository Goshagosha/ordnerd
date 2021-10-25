import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/models/link.dart';
import 'package:student_notekeeper/routes/lectures/lecture_edit.dart';
import 'package:student_notekeeper/widgets/lecture/lecture_qr.dart';
import 'package:student_notekeeper/widgets/link/link_widget.dart';

class LectureRoute extends StatefulWidget {
  Lecture lecture;

  LectureRoute({Key? key, required this.lecture}) : super(key: key);

  @override
  State<LectureRoute> createState() => _LectureRouteState();
}

class _LectureRouteState extends State<LectureRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.lecture.name),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (context) => const [
                PopupMenuItem(child: InkWell(child: Text("QR")), value: "qr"),
                PopupMenuItem(
                    child: InkWell(child: Text("Edit")), value: "edit"),
                PopupMenuItem(
                    child: InkWell(child: Text("Delete")), value: "delete"),
              ],
              onSelected: (val) {
                switch (val) {
                  case "qr":
                    showDialog(
                        context: context,
                        builder: (context) =>
                            QrLectureDialog(lecture: widget.lecture));
                    break;
                  case "edit":
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LectureEditRoute(
                                  lecture: widget.lecture,
                                )));
                    break;
                  case "delete":
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Delete"))
                            ],
                          );
                        }).then((confirmed) {
                      if (confirmed) {
                        // BlocProvider.of(context)!
                        //     .bloc
                        //     .deleteLecture(widget.lecture.dbId!);
                        Navigator.pop(context);
                      }
                    });
                    break;
                }
              },
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            if (widget.lecture.address != null)
              ListTile(
                title: Text(widget.lecture.address!),
                subtitle: const Text("lecture address"),
              ),
            if (widget.lecture.tutoriumAddress != null)
              ListTile(
                title: Text(widget.lecture.tutoriumAddress!),
                subtitle: const Text("tutorium address"),
              ),
            for (Link each in widget.lecture.links.values)
              LinkWidget(link: each),
            if (widget.lecture.customNotes != null)
              Text(widget.lecture.customNotes!)
          ],
        ));
  }
}
