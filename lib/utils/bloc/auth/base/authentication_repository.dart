import 'dart:async';

import 'package:flutter/cupertino.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  changeRequestSatisfied
}

abstract class AuthenticationRepository {
  @protected
  final controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unknown;
    yield* controller.stream;
  }

  Future<Object?> logInImplementation({
    required String email,
    required String password,
  });

  Future<void> logOutImplementation();

  Future<Object?> registrationImplementation({
    required String email,
    required String password,
  });

  Future<Object?> register({
    required String email,
    required String password,
  }) {
    return registrationImplementation(email: email, password: password)
        .then((result) => logIn(email: email, password: password));
  }

  Future<Object?> logIn({
    required String email,
    required String password,
  }) {
    return logInImplementation(email: email, password: password)
        .then((result) => controller.add(AuthenticationStatus.authenticated));
  }

  Future<void> logOut() {
    return logOutImplementation()
        .then((value) => controller.add(AuthenticationStatus.unauthenticated));
  }

  void dispose() => controller.close();
}
