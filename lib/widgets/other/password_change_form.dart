import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_notekeeper/utils/bloc/login/login_bloc.dart';
import 'package:student_notekeeper/utils/bloc/login/login_events.dart';
import 'package:student_notekeeper/utils/bloc/login/login_states.dart';
import 'package:formz/formz.dart';
import 'package:student_notekeeper/utils/bloc/password_change/password_change_bloc.dart';
import 'package:student_notekeeper/utils/bloc/password_change/password_events.dart';
import 'package:student_notekeeper/utils/bloc/password_change/password_states.dart';

class PasswordChangeForm extends StatelessWidget {
  const PasswordChangeForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordChangeBloc, PasswordChangeState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Failed to change password')));
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OldPasswordInput(),
            const Padding(padding: EdgeInsets.all(16)),
            _NewPasswordInput(),
            const Padding(padding: EdgeInsets.all(16)),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _OldPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordChangeBloc, PasswordChangeState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('oldPass_textField'),
          onChanged: (password) => context
              .read<PasswordChangeBloc>()
              .add(InputPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'OLD PASSWORD',
            errorText: state.password.invalid ? 'invalid old password' : null,
          ),
        );
      },
    );
  }
}

class _NewPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordChangeBloc, PasswordChangeState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('newPass_textField'),
          onChanged: (password) => context
              .read<PasswordChangeBloc>()
              .add(InputPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'NEW PASSWORD',
            errorText: state.password.invalid ? 'invalid new password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text('Login'),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_signup_raisedButton'),
                child: const Text('Signup'),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<LoginBloc>().add(const SignupSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}
