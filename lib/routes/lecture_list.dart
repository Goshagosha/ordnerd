import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/routes/lecture_edit.dart';
import 'package:student_notekeeper/utils/bloc/lecture_bloc.dart';
import 'package:student_notekeeper/utils/services/firestore_controller.dart';
import 'package:student_notekeeper/widgets/lecture_card.dart';

class LectureListRoute extends StatefulWidget {
  const LectureListRoute({Key? key}) : super(key: key);

  @override
  State<LectureListRoute> createState() => _LectureListRouteState();
}

class _LectureListRouteState extends State<LectureListRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Lectures"),
        ),
        body: StreamBuilder<List<Lecture>>(
            stream: lecturesStream(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Lecture>> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    for (Lecture l in snapshot.data!) LectureCard(lecture: l)
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LectureNewRoute()))));
  }
}
