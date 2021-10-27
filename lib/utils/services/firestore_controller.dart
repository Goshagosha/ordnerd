import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ordnerd/models/lecture.dart';

Stream<List<Lecture>> lecturesStream() {
  if (FirebaseAuth.instance.currentUser == null) {
    throw Exception("Querying lectures");
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('lectures')
      .snapshots()
      .map((snap) {
    return snap.docs
        .map((lectureMap) => Lecture.fromSnapshot(lectureMap))
        .toList();
  });
}
