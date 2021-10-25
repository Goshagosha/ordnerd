import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/utils/bloc/lecture/lecture_repository.dart';

class FirebaseLectureRepository implements LectureRepository {
  late final _lectures = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('lectures');

  @override
  Future<void> addNewLecture(Lecture lecture) {
    return _lectures.add(lecture.toMap());
  }

  @override
  Future<void> deleteLecture(Lecture lecture) async {
    return _lectures.doc(lecture.dbId).delete();
  }

  @override
  Stream<List<Lecture>> lectures() {
    return _lectures.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Lecture.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> updateLecture(Lecture lecture) {
    return _lectures.doc(lecture.dbId).update(lecture.toMap());
  }
}
