import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_repository.dart';
import 'package:ordnerd/utils/bloc/login/login_bloc.dart';
import 'package:ordnerd/utils/bloc/signup/signup_bloc.dart';
import 'package:ordnerd/widgets/authentication/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: BlocProvider(
          create: (context) {
            return SignupBloc(
                authenticationRepository:
                    RepositoryProvider.of<AuthenticationRepository>(context));
          },
          child: const RegisterForm(),
        ),
      ),
    );
  }
}
