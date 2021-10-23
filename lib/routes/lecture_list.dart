import 'package:flutter/material.dart';
import 'package:student_notekeeper/routes/lecture_edit.dart';
import 'package:student_notekeeper/utils/bloc/lecture_bloc.dart';
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
        body: StreamBuilder<Map>(
            stream: BlocProvider.of(context)!.bloc.lectures,
            builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    for (MapEntry entry in snapshot.data!.entries)
                      LectureCard(id: entry.key)
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
