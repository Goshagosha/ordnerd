import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRoute extends StatefulWidget {
  AuthRoute({Key? key}) : super(key: key);

  @override
  _AuthRouteState createState() => _AuthRouteState();
}

class _AuthRouteState extends State<AuthRoute> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(hintText: "email"),
                    autocorrect: false,
                    controller: emailController,
                    enabled: snapshot.connectionState == ConnectionState.active,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "password"),
                    obscureText: true,
                    autocorrect: false,
                    controller: passwordController,
                    enabled: snapshot.connectionState == ConnectionState.active,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: OutlinedButton(
                      onPressed: () {
                        try {
                          FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to login")));
                        }
                      },
                      child: const Text('Login'),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
