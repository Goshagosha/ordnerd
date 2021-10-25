import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_notekeeper/utils/bloc/lecture/lecture_events.dart';
import 'package:student_notekeeper/utils/bloc/lecture/lecture_repository.dart';
import 'package:student_notekeeper/utils/bloc/lecture/lecture_states.dart';

class LectureBloc extends Bloc<LectureEvent, LectureState> {
  final LectureRepository _lectureRepository;
  StreamSubscription? _lectureSubscription;

  LectureBloc({required lectureRepository})
      : _lectureRepository = lectureRepository,
        super(const LecturesLoadInProgress()) {
    /// Fetching list of lectures:
    on<LecturesRequested>(onLoaded);
    on<LecturesUpdated>(onLecturesUpdated);

    /// Editing lectures:
    on<LectureDeleted>(onDeleted);
    on<LectureUpdated>(onUpdated);
    on<LectureAdded>(onAdded);
  }

  void onLoaded(LecturesRequested event, Emitter<LectureState> emit) {
    _lectureSubscription?.cancel();
    _lectureSubscription =
        _lectureRepository.lectures().listen((lectures) => add(
              LecturesUpdated(lectures),
            ));
  }

  void onAdded(LectureAdded event, Emitter<LectureState> emit) async =>
      await _lectureRepository.addNewLecture(event.lecture);

  void onUpdated(LectureUpdated event, Emitter<LectureState> emit) async =>
      await _lectureRepository.updateLecture(event.lecture);

  void onDeleted(LectureDeleted event, Emitter<LectureState> emit) async =>
      await _lectureRepository.deleteLecture(event.lecture);

  @override
  Future<void> close() async {
    _lectureSubscription?.cancel();
    super.close();
  }

  void onLecturesUpdated(LecturesUpdated event, Emitter<LectureState> emit) {
    emit(LecturesLoadSuccess(event.lectures));
  }
}
