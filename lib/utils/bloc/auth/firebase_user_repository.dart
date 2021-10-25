import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseUserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<String> getUserId() async {
    return _firebaseAuth.currentUser!.uid;
  }

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }
}
