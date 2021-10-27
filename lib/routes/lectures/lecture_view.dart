import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/models/helpers/linktype.dart';
import 'package:ordnerd/models/lecture.dart';
import 'package:ordnerd/routes/lectures/lecture_edit.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_bloc.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_events.dart';
import 'package:ordnerd/widgets/lecture/confirmation_dialog.dart';
import 'package:ordnerd/widgets/lecture/lecture_qr.dart';
import 'package:ordnerd/widgets/link/link_widget.dart';

class LectureViewPage extends StatefulWidget {
  Lecture lecture;

  LectureViewPage({Key? key, required this.lecture}) : super(key: key);

  static Route route({required Lecture lecture}) {
    return MaterialPageRoute(builder: (context) {
      return LectureViewPage(lecture: lecture);
    });
  }

  @override
  State<LectureViewPage> createState() => _LectureViewPageState();
}

class _LectureViewPageState extends State<LectureViewPage> {
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
                    Navigator.push(context,
                            LectureEditPage.route(lecture: widget.lecture))
                        .then((edited) => Navigator.pushReplacement(
                            context, LectureViewPage.route(lecture: edited)));
                    break;
                  case "delete":
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const ConfirmationDialog(
                              okayButtonTitle: "Delete");
                        }).then((confirmed) {
                      if (confirmed) {
                        BlocProvider.of<LectureBloc>(context)
                            .add(LectureDeleted(widget.lecture));
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
            if (widget.lecture.address.isNotEmpty)
              ListTile(
                title: Text(widget.lecture.address),
                subtitle: const Text("lecture address"),
              ),
            if (widget.lecture.tutoriumAddress.isNotEmpty)
              ListTile(
                title: Text(widget.lecture.tutoriumAddress),
                subtitle: const Text("tutorium address"),
              ),
            for (String key in linkType)
              if (widget.lecture.links[key]!.name.isNotEmpty)
                LinkWidget(link: widget.lecture.links[key]!),
            if (widget.lecture.customNotes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(widget.lecture.customNotes),
              )
          ],
        ));
  }
}
