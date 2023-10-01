import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/models/note_model.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/pages/pages.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();
    TaskBloc taskBloc = context.read<TaskBloc>();
    NoteBloc noteBloc = context.read<NoteBloc>();

    return StreamBuilder<int>(
        stream: appBloc.bottomIndex,
        builder: (context, snapshot) {
          int bottomIndex = snapshot.data ?? 0;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              elevation: 0,
              titleSpacing: 20,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMMM d, E').format(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  StreamBuilder<List<TaskVM>>(
                      stream: taskBloc.tasks,
                      builder: (context, snapshot) {
                        List<TaskVM> tasks = snapshot.data ?? [];
                        int pendingCount =
                            tasks.where((element) => !element.completed).length;

                        return Text(
                          pendingCount == 0
                              ? 'All tasks completed'
                              : '$pendingCount task${pendingCount == 1 ? '' : 's'} pending',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                ],
              ),
              centerTitle: false,
              actions: [
                if (bottomIndex != 1)
                  IconButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        if (bottomIndex == 0) {
                          // settings page
                        } else if (bottomIndex == 1) {
                          // FocusNode focusNode = FocusNode();
                          // taskBloc.addTask(TaskVM(
                          //   id: DateTime.now().millisecondsSinceEpoch,
                          //   completed: false,
                          //   text: '',
                          //   focusNode: focusNode,
                          // ));
                          // focusNode.requestFocus();
                        } else if (bottomIndex == 2) {
                          // add project
                        } else if (bottomIndex == 3) {
                          DateTime now = DateTime.now();
                          FocusNode focusNode = FocusNode();
                          noteBloc.addNote(NoteVM(
                            id: now.millisecondsSinceEpoch,
                            pinned: false,
                            text: '',
                            dateTime: now,
                            focusNode: focusNode,
                          ));
                          focusNode.requestFocus();
                        }
                      },
                      icon: Icon(
                        bottomIndex == 0
                            ? Icons.settings_outlined
                            : Icons.add_box,
                        size: bottomIndex == 0 ? 24 : 32,
                        color: bottomIndex == 0 ? null : Colors.blue,
                      ))
              ],
            ),
            body: IndexedStack(
              index: bottomIndex,
              children: [
                MultiProvider(
                  providers: [
                    Provider(create: (context) => taskBloc),
                    Provider(create: (context) => noteBloc),
                  ],
                  child: const HomePage(),
                ),
                Provider(
                  create: (context) => taskBloc,
                  child: const TaskPage(),
                ),
                ProjectPage(),
                Provider(
                  create: (context) => noteBloc,
                  child: const NotePage(),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: bottomIndex,
              onTap: (int index) {
                HapticFeedback.selectionClick();
                appBloc.setBottomIndex(index);
              },
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              showUnselectedLabels: true,
              enableFeedback: true,
              elevation: 10,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.rocket_launch), label: 'Projects'),
                BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
              ],
            ),
          );
        });
  }
}
