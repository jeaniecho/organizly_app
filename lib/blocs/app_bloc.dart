import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_to_do/blocs/db_bloc.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/repos/apple_icloud_repo.dart';

class AppBloc {
  TaskBloc taskBloc;
  ProjectBloc projectBloc;
  NoteBloc noteBloc;

  final BehaviorSubject<int> _bottomIndex = BehaviorSubject.seeded(0);
  Stream<int> get bottomIndex => _bottomIndex.stream;
  Function get setBottomIndex => _bottomIndex.add;

  final BehaviorSubject<bool> _darkMode = BehaviorSubject.seeded(false);
  Stream<bool> get darkMode => _darkMode.stream;

  AppBloc(this.taskBloc, this.projectBloc, this.noteBloc) {
    readData('darkMode').then((value) => _darkMode.add(value ?? false));
  }

  setDarkMode(bool value) {
    _darkMode.add(value);
    saveData('darkMode', value);
  }

  saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      print("Invalid Type");
    }
  }

  Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  uploadToICloud() async {
    AppleICloudRepo iCloudRepo = AppleICloudRepo();

    List<String> dbs = ['tasks', 'projects', 'notes'];

    for (String db in dbs) {
      String dbPath = await getDatabasesPath();
      String path = join(dbPath, '$db.db');
      iCloudRepo.upload(path: path, dbName: db);
    }
  }

  downloadFromICloud() async {
    AppleICloudRepo iCloudRepo = AppleICloudRepo();

    List<DBBloc> dbs = [taskBloc, projectBloc, noteBloc];

    for (DBBloc db in dbs) {
      await db.closeDB();
      String path = join(await getDatabasesPath(), '${db.dbName}.db');
      iCloudRepo.download(
          path: path,
          dbName: db.dbName,
          onDone: () {
            db.initBloc();
          });
    }
  }
}
