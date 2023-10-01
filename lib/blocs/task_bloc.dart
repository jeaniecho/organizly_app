import 'package:rxdart/subjects.dart';
import 'package:what_to_do/mocks/task_mock.dart';
import 'package:what_to_do/models/task_model.dart';

class TaskBloc {
  final BehaviorSubject<List<TaskVM>> _tasks = BehaviorSubject.seeded([]);
  Stream<List<TaskVM>> get tasks => _tasks.stream;

  final BehaviorSubject<List<TaskVM>> _pendingTasks =
      BehaviorSubject.seeded([]);
  Stream<List<TaskVM>> get pendingTasks => _pendingTasks.stream;

  final BehaviorSubject<List<TaskVM>> _completedTasks =
      BehaviorSubject.seeded([]);
  Stream<List<TaskVM>> get completedTasks => _completedTasks.stream;

  TaskBloc() {
    getMockTasks();
  }

  getMockTasks() {
    _tasks.add(taskMockList0);

    List<TaskVM> pending =
        taskMockList0.where((element) => !element.completed).toList();
    _pendingTasks.add(pending);
    List<TaskVM> completed =
        taskMockList0.where((element) => element.completed).toList();
    _completedTasks.add(completed);
  }

  toggleTask(TaskVM task) {
    List<TaskVM> allTasks = _tasks.value;
    int index = allTasks.indexWhere((element) => element.id == task.id);
    allTasks[index] = task.copyWith(completed: !task.completed);
    _tasks.add(allTasks);
  }

  editTask(TaskVM task, String text) {
    List<TaskVM> allTasks = _tasks.value;
    int index = allTasks.indexWhere((element) => element.id == task.id);
    allTasks[index] = task.copyWith(text: text);
    _tasks.add(allTasks);
  }
}
