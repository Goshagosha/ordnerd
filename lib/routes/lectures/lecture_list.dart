import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordnerd/models/lecture.dart';
import 'package:ordnerd/routes/other/options_page.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_bloc.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_events.dart';
import 'package:ordnerd/utils/bloc/lecture/lecture_states.dart';
import 'package:ordnerd/utils/settings.dart';
import 'package:ordnerd/widgets/lecture/lecture_card.dart';

class LectureList extends StatefulWidget {
  LectureList({required context, Key? key}) : super(key: key) {
    BlocProvider.of<LectureBloc>(context).add(LecturesRequested());
  }

  static const String routeName = '/list';

  @override
  State<LectureList> createState() => _LectureListState();
}

class _LectureListState extends State<LectureList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Lectures"),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => Navigator.of(context, rootNavigator: true)
                    .push(OptionsPage.route()))
          ],
        ),
        body: BlocBuilder<LectureBloc, LectureState>(
            builder: (BuildContext context, LectureState state) {
          switch (state.status) {
            case LectureStateStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LectureStateStatus.failed:
              return const Center(
                  child: Text("Failed to load the list of lectures"));
            case LectureStateStatus.done:
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: boundWidth,
                  child: Column(
                    children: <Widget>[
                      for (Lecture l in (state as LecturesLoadSuccess).lectures)
                        LectureCard(
                          lecture: l,
                          key: Key(l.hashCode.toString()),
                        )
                    ],
                  ),
                ),
              );
          }
        }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(
                  context,
                  '/list/edit',
                )));
  }
}
