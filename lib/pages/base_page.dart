import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/pages/pages.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();
    TaskBloc taskBloc = context.read<TaskBloc>();

    return StreamBuilder<int>(
        stream: appBloc.bottomIndex,
        builder: (context, snapshot) {
          int bottomIndex = snapshot.data ?? 0;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
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
                          '$pendingCount tasks pending',
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
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings_outlined,
                      size: 24,
                    ))
              ],
            ),
            body: IndexedStack(
              index: bottomIndex,
              children: [
                MultiProvider(
                  providers: [Provider(create: (context) => taskBloc)],
                  child: HomePage(),
                ),
                Provider(
                  create: (context) => taskBloc,
                  child: const TaskPage(),
                ),
                ProjectPage(),
                NotePage(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: bottomIndex,
              onTap: (int index) => appBloc.setBottomIndex(index),
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
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Task'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.rocket_launch), label: 'Project'),
                BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Note'),
              ],
            ),
          );
        });
  }
}
