import 'package:equatable/equatable.dart';
import 'package:student_notekeeper/models/lecture.dart';

enum LectureStateStatus { loading, done, failed }

abstract class LectureState extends Equatable {
  final LectureStateStatus status;

  const LectureState({required this.status});

  @override
  List<Object> get props => [status];
}

class LecturesLoadInProgress extends LectureState {
  const LecturesLoadInProgress() : super(status: LectureStateStatus.loading);
}

class LecturesLoadSuccess extends LectureState {
  final List<Lecture> lectures;
  const LecturesLoadSuccess([this.lectures = const []])
      : super(status: LectureStateStatus.done);

  @override
  List<Object> get props => [status, lectures];

  @override
  String toString() => 'LecturesLoadSuccess {lectures: $lectures}';
}

class LecturesLoadFailure extends LectureState {
  const LecturesLoadFailure() : super(status: LectureStateStatus.failed);
}
