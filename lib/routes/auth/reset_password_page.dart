import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/models/authentication/email.dart';
import 'package:ordnerd/utils/bloc/auth/base/user_repository.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key? key}) : super(key: key);
  EmailValidationError? invalidity;
  String? email;

  static Route route() =>
      MaterialPageRoute(builder: (_) => ResetPasswordPage());

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Align(
            alignment: const Alignment(0, -1 / 2),
            child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text(
                      "Please enter your email and we will send you the reset link."),
                  const Padding(padding: EdgeInsets.all(8)),
                  TextField(
                    key: const Key('resetForm_emailInput_textField'),
                    onChanged: (email) => setState(() {
                      widget.email = email;
                      widget.invalidity = Email.dirty(email).validator(email);
                    }),
                    decoration: InputDecoration(
                      labelText: 'email',
                      errorText:
                          widget.invalidity != null ? 'invalid email' : null,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8)),
                  ElevatedButton(
                    key: const Key('resetForm_reset_button'),
                    child: const Text('Send reset link'),
                    onPressed: widget.invalidity == null
                        ? () {
                            try {
                              RepositoryProvider.of<UserRepository>(context)
                                  .sendPasswordResetEmail(email: widget.email!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Password reset link sent to your email")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Password reset link sent to your email")));
                            }
                          }
                        : null,
                  )
                ]))));
  }
}
