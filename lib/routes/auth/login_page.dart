import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_repository.dart';
import 'package:ordnerd/utils/bloc/login/login_bloc.dart';
import 'package:ordnerd/widgets/authentication/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
                authenticationRepository:
                    RepositoryProvider.of<AuthenticationRepository>(context));
          },
          child: const LoginForm(),
        ),
      ),
    );
  }
}
