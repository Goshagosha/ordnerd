import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_notekeeper/constants.dart';
import 'package:student_notekeeper/lecture_bloc.dart';
import 'package:student_notekeeper/lecture_edit.dart';
import 'package:student_notekeeper/link.dart';

class Lecture {
  String name;
  int? dbId;
  String address;
  String tutoriumAddress;
  String customNotes;

  Map<String, Link> links = {for (String l in linkTypes) l: Link("", l)};

  Lecture(
    this.name, {
    this.dbId,
    this.address = "",
    this.tutoriumAddress = "",
    this.customNotes = "",
  });

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'id': dbId,
      'address': address,
      'tutorium_address': tutoriumAddress,
      'custom_notes': customNotes
    };
  }
}

class LectureCard extends StatefulWidget {
  final int id;

  const LectureCard({Key? key, required this.id}) : super(key: key);

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map>(
        stream: BlocProvider.of(context)!.bloc.lectures,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Lecture l = snapshot.data![widget.id];
            return Card(
                child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LectureRoute(id: widget.id, lecture: l)));
              },
              child: ListTile(
                title: Text(
                  l.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class LectureRoute extends StatefulWidget {
  final int id;
  Lecture lecture;

  LectureRoute({Key? key, required this.id, required this.lecture})
      : super(key: key);

  @override
  State<LectureRoute> createState() => _LectureRouteState();
}

class _LectureRouteState extends State<LectureRoute> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map>(
        stream: BlocProvider.of(context)!.bloc.lectures,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.containsKey(widget.id)) {
            widget.lecture = snapshot.data![widget.id];
            return Scaffold(
                appBar: AppBar(
                  title: Text(widget.lecture.name),
                  actions: <Widget>[
                    PopupMenuButton(
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                            child: InkWell(child: Text("Edit")), value: "edit"),
                        PopupMenuItem(
                            child: InkWell(child: Text("Delete")),
                            value: "delete"),
                      ],
                      onSelected: (val) {
                        switch (val) {
                          case "edit":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LectureEditRoute(
                                          lecture: widget.lecture,
                                        )));
                            break;
                          case "delete":
                            BlocProvider.of(context)!
                                .bloc
                                .deleteLecture(widget.id);
                            Navigator.pop(context);
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
                    const Divider(),
                    for (Link each in widget.lecture.links.values)
                      if (each.name.isNotEmpty) LinkWidget(link: each),
                    const Divider(),
                    if (widget.lecture.customNotes.isNotEmpty)
                      Text(widget.lecture.customNotes)
                  ],
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
