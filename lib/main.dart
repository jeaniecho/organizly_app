import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/pages/pages.dart';
import 'package:what_to_do/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = AppBloc();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([appBloc.darkMode]),
        builder: (context, snapshot) {
          bool darkMode = snapshot.data?[0] == true;

          return MaterialApp(
            title: 'Organizly',
            debugShowCheckedModeBanner: false,
            theme: OGThemes.lightTheme,
            darkTheme: OGThemes.darkTheme,
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            home: MultiProvider(providers: [
              Provider(create: (context) => appBloc),
              Provider(create: (context) => TaskBloc()),
              Provider(create: (context) => ProjectBloc()),
              Provider(create: (context) => NoteBloc()),
            ], child: const BasePage()),
          );
        });
  }
}
