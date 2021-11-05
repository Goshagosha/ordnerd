import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/models/helpers/linktype.dart';
import 'package:ordnerd/models/lecture.dart';
import 'package:ordnerd/routes/other/qr_scanner.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_bloc.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_events.dart';
import 'package:ordnerd/widgets/link/link_edit.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LectureEditPage extends StatefulWidget {
  late final Lecture? lecture;
  late final bool _isNew;

  LectureEditPage({Key? key, required context}) : super(key: key) {
    lecture = ModalRoute.of(context)?.settings.arguments as Lecture;

    _isNew = lecture?.dbId == null;

    /// Only instantiate new if not in database, do not instantiate new if its freshly imported:
    lecture ??= Lecture();
  }

  static const routeName = '/list/edit';

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
          if (!kIsWeb)
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () {
                Navigator.of(context).pushReplacement(QRScannerPage.route());
              },
            ),
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                BlocProvider.of<LectureBloc>(context).add(widget._isNew
                    ? LectureAdded(widget.lecture!)
                    : LectureUpdated(widget.lecture!));
                Navigator.of(context).pop(widget.lecture);
              }),
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
            for (String key in linkType)
              LinkEditorWidget(link: widget.lecture!.links[key]!),
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
