import 'package:equatable/equatable.dart';

abstract class PasswordValidationEvent extends Equatable {
  const PasswordValidationEvent();

  @override
  List<Object?> get props => [];
}

class InputPasswordChanged extends PasswordValidationEvent {
  const InputPasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}
