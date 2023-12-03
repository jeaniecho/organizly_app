import 'package:sqflite/sqflite.dart';

abstract class DBBloc {
  late final Database database;
  late String dbName;

  initBloc();

  closeDB();
}
