import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/routes/auth/login_page.dart';
import 'package:ordnerd/routes/other/privacy_policy_page.dart';
import 'package:ordnerd/utils/bloc/login/login_bloc.dart';
import 'package:ordnerd/utils/bloc/login/login_events.dart';
import 'package:ordnerd/utils/bloc/login/login_states.dart';
import 'package:formz/formz.dart';
import 'package:ordnerd/utils/bloc/signup/signup_bloc.dart';
import 'package:ordnerd/utils/bloc/signup/signup_events.dart';
import 'package:ordnerd/utils/bloc/signup/signup_states.dart';
import 'package:ordnerd/utils/settings.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Registration failure')));
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 2),
        child: Container(
          constraints: boundWidth,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _EmailInput(),
            const Padding(padding: EdgeInsets.all(8)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(8)),
            _AcceptTermsWidget(),
            const Padding(padding: EdgeInsets.all(8)),
            _SignupButton(),
            const Padding(padding: EdgeInsets.all(8)),
            _ToLoginButton(),
          ]),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('registerForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<SignupBloc>().add(SignupEmailChanged(email)),
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
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('registerForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignupBloc>().add(SignupPasswordChanged(password)),
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

class _AcceptTermsWidget extends StatefulWidget {
  @override
  State<_AcceptTermsWidget> createState() => _AcceptTermsWidgetState();
}

class _AcceptTermsWidgetState extends State<_AcceptTermsWidget> {
  TapGestureRecognizer recognizer = TapGestureRecognizer();
  bool accepted = false;

  @override
  void dispose() {
    recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Row(
        children: [
          Checkbox(
              value: accepted,
              onChanged: (_) {
                context
                    .read<SignupBloc>()
                    .add(SignupTermsAcceptanceChanged(!accepted));
                setState(() {
                  accepted = !accepted;
                });
              }),
          Flexible(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    text:
                        'I consent to the processing of my data in accordance with the '),
                TextSpan(
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.primary),
                    text: 'privacy policy',
                    recognizer: recognizer
                      ..onTap = () => Navigator.of(context)
                          .push(PrivacyPolicyPage.route())),
                TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    text: ' of this app.'),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('registerForm_signup_raisedButton'),
                child: const Text('Sign up'),
                onPressed: state.canProceed()
                    ? () {
                        context.read<SignupBloc>().add(const SignupSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}

class _ToLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        child: const Text('I already have an account'),
        onPressed: () =>
            Navigator.of(context).pushReplacement(LoginPage.route()));
  }
}
