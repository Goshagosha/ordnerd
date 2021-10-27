import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordnerd/models/lecture.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_repository.dart';

class FirebaseLectureRepository extends LectureRepository {
  CollectionReference? _lectures;

  FirebaseLectureRepository({required userRepository})
      : super(userRepository: userRepository);

  Future<void> initLectures() async {
    if (_lectures == null) {
      final String uid = await getUID();
      DocumentSnapshot userDocument =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!userDocument.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({});
      }
      _lectures = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('lectures');
    }
  }

  @override
  Future<void> addNewLecture(Lecture lecture) {
    return _lectures!.add(lecture.toMap());
  }

  @override
  Future<void> deleteLecture(Lecture lecture) async {
    return _lectures!.doc(lecture.dbId).delete();
  }

  @override
  Future<Stream<List<Lecture>>> lectures() async {
    await initLectures();
    return _lectures!.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Lecture.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> updateLecture(Lecture lecture) {
    return _lectures!.doc(lecture.dbId).update(lecture.toMap());
  }
}
