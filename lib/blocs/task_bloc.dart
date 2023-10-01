import 'package:rxdart/subjects.dart';
import 'package:what_to_do/mocks/task_mock.dart';
import 'package:what_to_do/models/task_model.dart';

class TaskBloc {
  final BehaviorSubject<List<TaskVM>> _tasks = BehaviorSubject.seeded([]);
  Stream<List<TaskVM>> get tasks => _tasks.stream;

  TaskBloc() {
    getMockTasks();
  }

  getMockTasks() {
    _tasks.add(taskMockList0);
  }
}
