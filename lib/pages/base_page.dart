import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/models/note_model.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/pages/pages.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();
    TaskBloc taskBloc = context.read<TaskBloc>();
    ProjectBloc projectBloc = context.read<ProjectBloc>();
    NoteBloc noteBloc = context.read<NoteBloc>();

    Color selectedColor = const Color(0xff242424);
    Color defaultColor = const Color(0xffcccccc);
    Color primaryColor = const Color(0xff39A0FF);

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return StreamBuilder<int>(
        stream: appBloc.bottomIndex,
        builder: (context, snapshot) {
          int bottomIndex = snapshot.data ?? 0;

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: const Color(0xffFCFDFF),
            // floatingActionButton: FloatingActionButton(
            //   backgroundColor: const Color(0xffD8ECFF),
            //   foregroundColor: const Color(0xff39A0FF),
            //   elevation: 5,
            //   mini: true,
            //   child: const Icon(Icons.add),
            //   onPressed: () {},
            // ),
            endDrawer: Drawer(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  const SizedBox(height: 64),
                  Image.asset(
                    'assets/app_icon_transparent.png',
                    width: 120,
                  ),
                  Text(
                    'Organizly',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: selectedColor,
                    ),
                  ),
                  Container(
                    height: 1,
                    width: 200,
                    margin: const EdgeInsets.symmetric(vertical: 32),
                    color: defaultColor,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'aaa',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: selectedColor),
                    ),
                  ),
                  const Spacer(),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 32),
                        child: Text('v1.0'),
                      )),
                  const SizedBox(height: 64),
                ],
              ),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              elevation: 0,
              titleSpacing: 20,
              title: Row(
                children: [
                  Image.asset(
                    'assets/appbar_logo.png',
                    width: 36,
                  ),
                  const SizedBox(width: 6),
                  Column(
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
                            int pendingCount = tasks
                                .where((element) => !element.completed)
                                .length;

                            return Text(
                              pendingCount == 0 && tasks.isNotEmpty
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
                ],
              ),
              centerTitle: false,
              actions: [
                IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      scaffoldKey.currentState?.openEndDrawer();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const SettingsPage()));
                    },
                    icon: Image.asset(
                      'assets/icons/grid.png',
                      width: 24,
                      color: primaryColor,
                    ))
              ],
            ),
            body: IndexedStack(
              index: bottomIndex,
              children: [
                MultiProvider(
                  providers: [
                    Provider(create: (context) => appBloc),
                    Provider(create: (context) => taskBloc),
                    Provider(create: (context) => noteBloc),
                    Provider(create: (context) => projectBloc),
                  ],
                  child: const HomePage(),
                ),
                Provider(
                  create: (context) => taskBloc,
                  child: const TaskPage(),
                ),
                Provider(
                  create: (context) => projectBloc,
                  child: const ProjectPage(),
                ),
                Provider(
                  create: (context) => noteBloc,
                  child: const NotePage(),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Material(
                elevation: 0,
                color: const Color(0xffFCFDFF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    currentIndex: bottomIndex,
                    onTap: (int index) {
                      HapticFeedback.selectionClick();
                      appBloc.setBottomIndex(index);
                    },
                    selectedItemColor: selectedColor,
                    unselectedItemColor: defaultColor,
                    selectedFontSize: 12,
                    unselectedFontSize: 12,
                    showUnselectedLabels: true,
                    enableFeedback: true,
                    elevation: 0,
                    selectedLabelStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          'assets/icons/home.png',
                          width: 24,
                          color:
                              bottomIndex == 0 ? selectedColor : defaultColor,
                        ),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            'assets/icons/tasks.png',
                            width: 24,
                            color:
                                bottomIndex == 1 ? selectedColor : defaultColor,
                          ),
                          label: 'Tasks'),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            'assets/icons/projects.png',
                            width: 24,
                            color:
                                bottomIndex == 2 ? selectedColor : defaultColor,
                          ),
                          label: 'Projects'),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            'assets/icons/notes.png',
                            width: 24,
                            color:
                                bottomIndex == 3 ? selectedColor : defaultColor,
                          ),
                          label: 'Notes'),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
