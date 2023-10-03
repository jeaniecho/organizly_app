import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff39A0FF)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffFCFDFF),
        ),
        scaffoldBackgroundColor: const Color(0xffFCFDFF),
        splashColor: Colors.transparent,
        primaryColor: const Color(0xff39A0FF),
        focusColor: const Color(0xff39A0FF),
        highlightColor: Colors.transparent,
        useMaterial3: true,
        fontFamily: 'NotoSansKR',
      ),
      home: MultiProvider(providers: [
        Provider(create: (context) => AppBloc()),
        Provider(create: (context) => TaskBloc()),
        Provider(create: (context) => ProjectBloc()),
        Provider(create: (context) => NoteBloc()),
      ], child: const BasePage()),
    );
  }
}
