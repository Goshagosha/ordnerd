import 'package:flutter/material.dart';
import 'package:student_notekeeper/routes/lecture_list.dart';
import 'package:student_notekeeper/utils/bloc/lecture_bloc.dart';
import 'package:student_notekeeper/utils/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: LecturesBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: heidelbergPrimary,
        ),
        home: const LectureListRoute(),
      ),
    );
  }
}
