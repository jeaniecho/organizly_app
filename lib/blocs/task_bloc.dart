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

  toggleTask(TaskVM task) {
    List<TaskVM> allTasks = _tasks.value;
    allTasks.removeWhere((element) => element.id == task.id);
    allTasks.add(task.copyWith(completed: !task.completed));
    _tasks.add(allTasks);
  }

  addTask(TaskVM task) {
    List<TaskVM> allTasks = _tasks.value;
    allTasks.add(task);
    _tasks.add(allTasks);
  }

  editTask(TaskVM task, String text) {
    List<TaskVM> allTasks = _tasks.value;
    int index = allTasks.indexWhere((element) => element.id == task.id);
    allTasks[index] = task.copyWith(text: text);
    _tasks.add(allTasks);
  }

  removeTask(TaskVM task) {
    List<TaskVM> allTasks = _tasks.value;
    allTasks.removeWhere((element) => element.id == task.id);
    _tasks.add(allTasks);
  }

  clearCompletedTasks() {
    List<TaskVM> allTasks = _tasks.value;
    allTasks.removeWhere((element) => element.completed);
    _tasks.add(allTasks);
  }
}
