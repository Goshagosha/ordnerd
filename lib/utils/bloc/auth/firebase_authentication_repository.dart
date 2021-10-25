import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/authentication_repository.dart';

class FirebaseAuthenticationRepository extends AuthenticationRepository {
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;

  @override
  Future<UserCredential> logInImplementation(
      {required String email, required String password}) {
    return _firebaseAuthInstance.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> logOutImplementation() {
    return _firebaseAuthInstance.signOut();
  }

  @override
  Future<UserCredential> registrationImplementation(
      {required String email, required String password}) {
    return _firebaseAuthInstance.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}
