import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:student_notekeeper/models/authentication/models.dart';
import 'package:student_notekeeper/utils/bloc/password_validation/password_events.dart';
import 'package:student_notekeeper/utils/bloc/password_validation/password_states.dart';

class PasswordValidationBloc
    extends Bloc<PasswordValidationEvent, PasswordValidationState> {
  PasswordValidationBloc() : super(const PasswordValidationState()) {
    on<InputPasswordChanged>(_onInputChanged);
  }

  void _onInputChanged(
      InputPasswordChanged event, Emitter<PasswordValidationState> emit) {
    final password = Password.dirty(event.password);
    emit(
        state.copyWith(password: password, status: Formz.validate([password])));
  }
}
