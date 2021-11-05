import 'package:ordnerd/models/lecture.dart';
import 'package:ordnerd/utils/bloc/auth/base/user_repository.dart';

abstract class LectureRepository {
  final UserRepository _userRepository;

  LectureRepository({required userRepository})
      : _userRepository = userRepository;

  Future<Stream<List<Lecture>>> lectures();

  Future<String> getUID() async {
    return _userRepository.getUserId();
  }

  Future<void> addNewLecture(Lecture lecture);

  Future<void> deleteLecture(Lecture lecture);

  Future<void> updateLecture(Lecture lecture);

  Future<String> pushShared(Lecture lecture);

  Future<Lecture> fetchShared(String lectureId);
}
