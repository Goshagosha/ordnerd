import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
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
        .then((result) => _controller.add(AuthenticationStatus.authenticated));
  }

  Future<void> logOut() {
    return logOutImplementation()
        .then((value) => _controller.add(AuthenticationStatus.unauthenticated));
  }

  void dispose() => _controller.close();
}
