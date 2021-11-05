import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/routes/auth/login_page.dart';
import 'package:ordnerd/routes/auth/register_page.dart';
import 'package:ordnerd/routes/lectures/lecture_edit.dart';
import 'package:ordnerd/routes/lectures/lecture_list.dart';
import 'package:ordnerd/routes/lectures/lecture_view.dart';
import 'package:ordnerd/routes/other/splash_page.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_bloc.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_repository.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_states.dart';
import 'package:ordnerd/utils/bloc/auth/base/user_repository.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_bloc.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_repository.dart';
import 'package:ordnerd/utils/settings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
      routes: {
        LectureList.routeName: (context) => LectureList(
              context: context,
            ),
        LectureViewPage.routeName: (context) =>
            LectureViewPage(context: context),
        LectureEditPage.routeName: (context) =>
            LectureEditPage(context: context),
      },
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil<void>(
                    LectureList.routeName, (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                    kIsWeb ? LoginPage.route() : RegisterPage.route(),
                    (route) => false);
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
