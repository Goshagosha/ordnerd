import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_bloc.dart';
import 'package:ordnerd/utils/bloc/auth/base/authentication_events.dart';
import 'package:ordnerd/utils/bloc/auth/base/user_repository.dart';
import 'package:ordnerd/utils/settings.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const OptionsPage());
  }

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Options"),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: boundWidth,
            child: ListView(
              children: [
                ListTile(
                  title: FutureBuilder(
                      future: RepositoryProvider.of<UserRepository>(context)
                          .getHumanReadableIdentifier(),
                      builder: (_, AsyncSnapshot<String> snap) {
                        if (snap.hasData) {
                          return Text(snap.data!);
                        } else {
                          return const LinearProgressIndicator();
                        }
                      }),
                  subtitle: const Text("profile"),
                  trailing: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationLogoutRequested()),
                  ),
                ),
                ListTile(
                  title: const Text("Reset password"),
                  trailing: const Icon(Icons.lock),
                  onTap: () {
                    RepositoryProvider.of<UserRepository>(context)
                        .sendPasswordResetEmail();
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text("Reset password"),
                              content: const Text(
                                  "Link with instructions has been sent to your email address"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("OK"))
                              ],
                            ));
                  },
                )
              ],
            ),
          ),
        ));
  }
}

resetPassword(context) {
  RepositoryProvider.of<UserRepository>(context).sendPasswordResetEmail();
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: const Text("Reset password"),
            content: const Text(
                "Link with instructions has been sent to your email address"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          ));
}
