import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ordnerd/app.dart';
import 'package:ordnerd/utils/bloc/auth/base/user_repository.dart';
import 'package:ordnerd/utils/bloc/auth/firebase_authentication_repository.dart';
import 'package:ordnerd/utils/bloc/auth/firebase_user_repository.dart';
import 'package:ordnerd/utils/bloc/lecture/firebase_lecture_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  UserRepository userRepository = FirebaseUserRepository();

  runApp(App(
    authenticationRepository: FirebaseAuthenticationRepository(),
    userRepository: userRepository,
    lectureRepository:
        FirebaseLectureRepository(userRepository: userRepository),
  ));
}
