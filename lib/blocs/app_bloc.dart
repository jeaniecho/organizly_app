import 'package:rxdart/subjects.dart';

class AppBloc {
  final BehaviorSubject<int> _bottomIndex = BehaviorSubject.seeded(0);
  Stream<int> get bottomIndex => _bottomIndex.stream;
  Function get setBottomIndex => _bottomIndex.add;

  final BehaviorSubject<int> _taskCount = BehaviorSubject();
  Stream<int> get taskCount => _taskCount.stream;

  AppBloc() {
    getTaskCount();
  }

  getTaskCount() {
    _taskCount.add(42);
  }
}
