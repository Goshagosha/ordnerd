import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/authentication_bloc.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/authentication_events.dart';
import 'package:student_notekeeper/utils/bloc/auth/base/user_repository.dart';

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
        body: ListView(
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
              title: Text("Reset password"),
              trailing: Icon(Icons.lock),
              onTap: () => RepositoryProvider.of<UserRepository>(context)
                  .sendPasswordResetEmail(),
            )
          ],
        ));
  }
}
