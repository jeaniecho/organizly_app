import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/pages/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Provider(create: (context) => AppBloc(), child: const BasePage()),
    );
  }
}
