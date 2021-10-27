import 'package:firebase_auth/firebase_auth.dart';
import 'package:ordnerd/utils/bloc/auth/base/user_repository.dart';

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

  @override
  Future<String> getHumanReadableIdentifier() async {
    return _firebaseAuth.currentUser?.email ?? '';
  }

  @override
  Future<void> sendPasswordResetEmail({String? email}) {
    return _firebaseAuth.sendPasswordResetEmail(
        email: email ?? _firebaseAuth.currentUser!.email!);
  }
}
