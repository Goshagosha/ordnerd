import 'package:flutter/material.dart';
import 'package:student_notekeeper/constants.dart';
import 'package:student_notekeeper/lecture.dart';
import 'package:student_notekeeper/lecture_bloc.dart';
import 'package:student_notekeeper/lecture_edit.dart';

Lecture l1 = Lecture("LA1");
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

class LectureListRoute extends StatefulWidget {
  const LectureListRoute({Key? key}) : super(key: key);

  @override
  State<LectureListRoute> createState() => _LectureListRouteState();
}

class _LectureListRouteState extends State<LectureListRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Lectures"),
        ),
        body: StreamBuilder<Map>(
            stream: BlocProvider.of(context)!.bloc.lectures,
            builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    for (MapEntry entry in snapshot.data!.entries)
                      LectureCard(id: entry.key)
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LectureNewRoute()))));
  }
}
