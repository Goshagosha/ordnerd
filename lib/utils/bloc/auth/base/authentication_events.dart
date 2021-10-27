import 'package:equatable/equatable.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_repository.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => const [];
}

class AuthenticationStatusChange extends AuthenticationEvent {
  final AuthenticationStatus status;

  const AuthenticationStatusChange(this.status);

  @override
  List<Object?> get props => [status];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
