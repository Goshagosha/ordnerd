import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:student_notekeeper/models/authentication/models.dart';

class PasswordChangeState extends Equatable {
  const PasswordChangeState(
      {this.status = FormzStatus.pure, this.password = const Password.pure()});

  final FormzStatus status;
  final Password password;

  PasswordChangeState copyWith({
    FormzStatus? status,
    Password? password,
  }) {
    return PasswordChangeState(
        status: status ?? this.status, password: password ?? this.password);
  }

  @override
  List<Object?> get props => [status, password];
}
