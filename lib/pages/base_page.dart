import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/pages/pages.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();

    return StreamBuilder<int>(
        stream: appBloc.bottomIndex,
        builder: (context, snapshot) {
          int bottomIndex = snapshot.data ?? 0;

          return Scaffold(
            appBar: AppBar(
              title: Text(DateTime.now().toString()),
            ),
            body: IndexedStack(
              index: bottomIndex,
              children: const [
                HomePage(),
                TaskPage(),
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
