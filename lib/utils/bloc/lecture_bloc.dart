import 'dart:async';
import 'package:flutter/material.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/utils/services/db_controller.dart';

class BlocProvider extends InheritedWidget {
  final LecturesBloc bloc;

  const BlocProvider({Key? key, required Widget child, required this.bloc})
      : super(key: key, child: child);

  static BlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BlocProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class LecturesBloc {
  final StreamController _lectureController;

  LecturesBloc() : _lectureController = StreamController<Map>.broadcast();

  get lectures {
    reloadLectures();
    return _lectureController.stream;
  }

  dispose() {
    _lectureController.close();
  }

  reloadLectures() async {
    _lectureController.sink.add(await DbProvider.db.loadLectures());
  }

  deleteLecture(int id) {
    DbProvider.db.deleteLecture(id).then((value) => reloadLectures());
  }

  saveLecture(Lecture l) {
    DbProvider.db.saveLecture(l).then((value) => reloadLectures());
  }
}
