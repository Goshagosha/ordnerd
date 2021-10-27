import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordnerd/models/authentication/models.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_repository.dart';
import 'package:ordnerd/utils/bloc/signup/signup_events.dart';
import 'package:ordnerd/utils/bloc/signup/signup_states.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignupState()) {
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupTermsAcceptanceChanged>(_onTermsAcceptanceChanged);
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
        email: email, status: Formz.validate([state.password, email])));
  }

  void _onPasswordChanged(
      SignupPasswordChanged event, Emitter<SignupState> emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
        password: password, status: Formz.validate([password, state.email])));
  }

  void _onTermsAcceptanceChanged(
      SignupTermsAcceptanceChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(accepted: event.accepted));
  }

  void _onSignupSubmitted(
      SignupSubmitted event, Emitter<SignupState> emit) async {
    if (state.status.isValidated && state.accepted) {
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
