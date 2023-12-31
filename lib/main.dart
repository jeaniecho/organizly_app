import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/pages/pages.dart';
import 'package:what_to_do/styles/themes.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TaskBloc taskBloc = TaskBloc();
    ProjectBloc projectBloc = ProjectBloc();
    NoteBloc noteBloc = NoteBloc();

    AppBloc appBloc = AppBloc(taskBloc, projectBloc, noteBloc);

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([appBloc.darkMode]),
        builder: (context, snapshot) {
          bool darkMode = snapshot.data?[0] == true;

          Future.delayed(const Duration(milliseconds: 600))
              .then((value) => FlutterNativeSplash.remove());

          return MaterialApp(
            title: 'Organizly',
            debugShowCheckedModeBanner: false,
            theme: OGThemes.lightTheme,
            darkTheme: OGThemes.darkTheme,
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            home: MultiProvider(providers: [
              Provider(create: (context) => appBloc),
              Provider(create: (context) => taskBloc),
              Provider(create: (context) => projectBloc),
              Provider(create: (context) => noteBloc),
            ], child: const BasePage()),
          );
        });
  }
}
