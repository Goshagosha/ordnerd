import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/routes/auth/login_page.dart';
import 'package:ordnerd/routes/lectures/lecture_list.dart';
import 'package:ordnerd/routes/other/splash_page.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_bloc.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_repository.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_states.dart';
import 'package:ordnerd/utils/bloc/auth/base/user_repository.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_bloc.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_repository.dart';
import 'package:ordnerd/utils/settings.dart';

class App extends StatelessWidget {
  const App(
      {Key? key,
      required this.authenticationRepository,
      required this.userRepository,
      required this.lectureRepository})
      : super(key: key);
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final LectureRepository lectureRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: RepositoryProvider.value(
          value: authenticationRepository,
          child: RepositoryProvider.value(
            value: lectureRepository,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<AuthenticationBloc>(
                    create: (_) => AuthenticationBloc(
                        authenticationRepository: authenticationRepository,
                        userRepository: userRepository)),
                BlocProvider<LectureBloc>(
                    create: (_) =>
                        LectureBloc(lectureRepository: lectureRepository)),
              ],
              child: const AppView(),
            ),
          )),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: heidelbergPrimary),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                    LectureList.route(), (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                    LoginPage.route(), (route) => false);
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
