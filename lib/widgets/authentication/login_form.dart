import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/routes/auth/register_page.dart';
import 'package:ordnerd/routes/auth/reset_password_page.dart';
import 'package:ordnerd/utils/bloc/login/login_bloc.dart';
import 'package:ordnerd/utils/bloc/login/login_events.dart';
import 'package:ordnerd/utils/bloc/login/login_states.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Authentication failure')));
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmailInput(),
            const Padding(padding: EdgeInsets.all(8)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(8)),
            _SigninButton(),
            const Padding(padding: EdgeInsets.all(8)),
            _ForgotButton(),
            const Padding(padding: EdgeInsets.all(8)),
            _ToRegisterPage(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'email',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.password.invalid
                ? 'invalid password (minimum of 6 symbols)'
                : null,
          ),
        );
      },
    );
  }
}

class _SigninButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text('Sign in'),
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

class _ForgotButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : OutlinedButton(
                key: const Key('loginForm_forgotButton_raisedButton'),
                child: const Text('I forgot my password'),
                onPressed: state.status.isSubmissionInProgress
                    ? () {}
                    : () =>
                        Navigator.of(context).push(ResetPasswordPage.route()),
              );
      },
    );
  }
}

class _ToRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        child: const Text('I don\'t have an account'),
        onPressed: () =>
            Navigator.of(context).pushReplacement(RegisterPage.route()));
  }
}
