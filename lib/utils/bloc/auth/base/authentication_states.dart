import 'package:equatable/equatable.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/authentication_repository.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;

  const AuthenticationState._({this.status = AuthenticationStatus.unknown});

  @override
  List<Object?> get props => [status];

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated()
      : this._(status: AuthenticationStatus.authenticated);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);
}
