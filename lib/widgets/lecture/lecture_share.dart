import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_repository.dart';
import 'package:ordnerd/models/lecture.dart';

class ShareLectureDialog extends StatelessWidget {
  final Lecture lecture;
  late final LectureRepository repo;
  ShareLectureDialog({Key? key, required this.lecture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    repo = RepositoryProvider.of<LectureRepository>(context);
    return AlertDialog(
        content: FutureBuilder(
      future: repo.pushShared(lecture),
      builder: (BuildContext context, AsyncSnapshot<String> snap) {
        if (snap.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(snap.data!),
              IconButton(
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: snap.data!)),
                  icon: const Icon(Icons.copy))
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
