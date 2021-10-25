import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/authentication_events.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/authentication_repository.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/authentication_states.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository,
      required UserRepository userRepository})
      : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChange>(_onAuthenticationStatusChange);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
    _authenticationRepository.status
        .listen((status) => add(AuthenticationStatusChange(status)));
  }

  void _onAuthenticationStatusChange(
      AuthenticationStatusChange event, emit) async {
    switch (event.status) {
      case AuthenticationStatus.authenticated:
        final userId = await _tryGetUserId();
        emit(userId != null
            ? const AuthenticationState.authenticated()
            : const AuthenticationState.unauthenticated());
        break;
      case AuthenticationStatus.unauthenticated:
        emit(const AuthenticationState.unauthenticated());
        break;
      default:
        emit(const AuthenticationState.unknown());
    }
  }

  Future<String?> _tryGetUserId() async {
    try {
      final id = await _userRepository.getUserId();
      return id;
    } catch (_) {
      return null;
    }
  }

  void _onLogoutRequested(AuthenticationLogoutRequested event, emit) async {}

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }
}
