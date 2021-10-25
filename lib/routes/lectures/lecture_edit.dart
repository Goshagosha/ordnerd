import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_notekeeper/models/helpers/linktype.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/models/link.dart';
import 'package:student_notekeeper/utils/bloc/lecture/lecture_bloc.dart';
import 'package:student_notekeeper/utils/bloc/lecture/lecture_events.dart';
import 'package:student_notekeeper/widgets/link/link_edit.dart';

class LectureEditPage extends StatefulWidget {
  Lecture? lecture;
  late final bool _isNew;

  LectureEditPage({Key? key, this.lecture}) : super(key: key) {
    _isNew = lecture == null;
    if (_isNew) {
      lecture = Lecture();
    }
  }

  static Route route({Lecture? lecture}) {
    return MaterialPageRoute(builder: (context) {
      return LectureEditPage(lecture: lecture);
    });
  }

  @override
  _LectureEditPageState createState() => _LectureEditPageState();
}

class _LectureEditPageState extends State<LectureEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget._isNew ? "New lecture" : "Edit " + widget.lecture!.name),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                BlocProvider.of<LectureBloc>(context).add(widget._isNew
                    ? LectureAdded(widget.lecture!)
                    : LectureUpdated(widget.lecture!));
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
              initialValue: widget.lecture!.name,
              decoration: const InputDecoration(hintText: "Name"),
              onChanged: (text) => widget.lecture!.name = text,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: widget.lecture!.address,
              decoration: const InputDecoration(hintText: "Address"),
              onChanged: (text) => widget.lecture!.address = text,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: widget.lecture!.tutoriumAddress,
              decoration: const InputDecoration(hintText: "Tutorium address"),
              onChanged: (text) => widget.lecture!.tutoriumAddress = text,
            ),
            for (String eachLinkType in linkType)
              LinkEditorWidget(link: Link(type: eachLinkType, name: '')),
            TextFormField(
              initialValue: widget.lecture!.customNotes,
              decoration: const InputDecoration(hintText: "Custom notes"),
              onChanged: (text) => widget.lecture!.customNotes = text,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
