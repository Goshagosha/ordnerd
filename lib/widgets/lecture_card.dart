import 'package:flutter/material.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/routes/lecture.dart';
import 'package:student_notekeeper/utils/bloc/lecture_bloc.dart';

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
