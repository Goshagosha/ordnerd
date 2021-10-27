import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ordnerd/models/authentication/models.dart';

class SignupState extends Equatable {
  const SignupState(
      {this.status = FormzStatus.pure,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.accepted = false});

  final FormzStatus status;
  final Email email;
  final Password password;
  final bool accepted;

  bool canProceed() {
    return accepted && status.isValid;
  }

  SignupState copyWith(
      {FormzStatus? status, Email? email, Password? password, bool? accepted}) {
    return SignupState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        accepted: accepted ?? this.accepted);
  }

  @override
  List<Object?> get props => [status, email, password, accepted];
}
