import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/routes/lectures/lecture_edit.dart';
import 'package:student_notekeeper/utils/bloc/lecture/lecture_bloc.dart';
import 'package:student_notekeeper/utils/bloc/lecture/lecture_states.dart';
import 'package:student_notekeeper/widgets/lecture/lecture_card.dart';

class LectureList extends StatefulWidget {
  const LectureList({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const LectureList());
  }

  @override
  State<LectureList> createState() => _LectureListState();
}

class _LectureListState extends State<LectureList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Lectures"),
        ),
        body: BlocBuilder<LectureBloc, LectureState>(
            builder: (BuildContext context, LectureState state) {
          switch (state.status) {
            case LectureStateStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LectureStateStatus.failed:
              return const Center(
                  child: Text("Failed to load the list of lectures"));
            case LectureStateStatus.done:
              return Column(
                children: <Widget>[
                  for (Lecture l in (state as LecturesLoadSuccess).lectures)
                    LectureCard(lecture: l)
                ],
              );
          }
        }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LectureNewRoute()))));
  }
}
