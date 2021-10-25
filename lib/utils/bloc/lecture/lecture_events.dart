import 'package:equatable/equatable.dart';
import 'package:student_notekeeper/models/lecture.dart';

abstract class LectureEvent extends Equatable {
  const LectureEvent();

  @override
  List<Object> get props => [];
}

class LecturesRequested extends LectureEvent {}

class LectureAdded extends LectureEvent {
  final Lecture lecture;

  const LectureAdded(this.lecture);

  @override
  List<Object> get props => [lecture];

  @override
  String toString() => 'AddLecture { lecture: $lecture }';
}

class LectureUpdated extends LectureEvent {
  final Lecture lecture;

  const LectureUpdated(this.lecture);

  @override
  List<Object> get props => [lecture];

  @override
  String toString() => 'UpdateLecture { lecture: $lecture }';
}

class LectureDeleted extends LectureEvent {
  final Lecture lecture;

  const LectureDeleted(this.lecture);

  @override
  List<Object> get props => [lecture];

  @override
  String toString() => 'DeleteLecture { lecture: $lecture }';
}

class LecturesUpdated extends LectureEvent {
  final List<Lecture> lectures;

  const LecturesUpdated(this.lectures);

  @override
  List<Object> get props => [lectures];

  @override
  String toString() => 'LecturesUpdated { lectures: $lectures }';
}
