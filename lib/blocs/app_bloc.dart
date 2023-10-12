import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc {
  final BehaviorSubject<int> _bottomIndex = BehaviorSubject.seeded(0);
  Stream<int> get bottomIndex => _bottomIndex.stream;
  Function get setBottomIndex => _bottomIndex.add;

  final BehaviorSubject<bool> _darkMode = BehaviorSubject.seeded(false);
  Stream<bool> get darkMode => _darkMode.stream;

  AppBloc() {
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
}
