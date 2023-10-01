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
    List<TaskVM> tasks = _tasks.value;
    tasks.removeWhere((element) => element.id == task.id);
    tasks.add(task.copyWith(completed: !task.completed));
    _tasks.add(tasks);
  }

  addTask(TaskVM task) {
    List<TaskVM> tasks = _tasks.value;
    tasks.insert(0, task);
    _tasks.add(tasks);
  }

  editTask(TaskVM task, String text) {
    try {
      List<TaskVM> tasks = _tasks.value;
      if (text.isEmpty) {
        tasks.removeWhere((element) => element.id == task.id);
      } else {
        int index = tasks.indexWhere((element) => element.id == task.id);
        tasks[index] = task.copyWith(text: text);
      }

      _tasks.add(tasks);
    } catch (e) {
      print('error in editTask: $text');
    }
  }

  removeTask(TaskVM task) {
    List<TaskVM> tasks = _tasks.value;
    tasks.removeWhere((element) => element.id == task.id);
    _tasks.add(tasks);
  }

  clearCompletedTasks() {
    List<TaskVM> tasks = _tasks.value;
    tasks.removeWhere((element) => element.completed);
    _tasks.add(tasks);
  }
}
