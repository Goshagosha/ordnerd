import 'package:flutter/material.dart';
import 'package:student_notekeeper/models/lecture.dart';

abstract class LectureRepository {
  Stream<List<Lecture>> lectures();

  Future<void> addNewLecture(Lecture lecture);

  Future<void> deleteLecture(Lecture lecture);

  Future<void> updateLecture(Lecture lecture);
}
