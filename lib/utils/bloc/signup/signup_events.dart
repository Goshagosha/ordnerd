import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupEmailChanged extends SignupEvent {
  const SignupEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  const SignupPasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

class SignupTermsAcceptanceChanged extends SignupEvent {
  const SignupTermsAcceptanceChanged(this.accepted);
  final bool accepted;

  @override
  List<Object?> get props => [accepted];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}
