import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordnerd/models/authentication/models.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_repository.dart';
import 'package:ordnerd/utils/bloc/login/login_events.dart';
import 'package:ordnerd/utils/bloc/login/login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
        email: email, status: Formz.validate([state.password, email])));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
        password: password, status: Formz.validate([password, state.email])));
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.logIn(
            email: state.email.value, password: state.password.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  void _onSignupSubmitted(
      SignupSubmitted event, Emitter<LoginState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.register(
            email: state.email.value, password: state.password.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
