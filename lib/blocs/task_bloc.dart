import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_to_do/mocks/task_mock.dart';
import 'package:what_to_do/models/task_model.dart';

class TaskBloc {
  late final Database taskDB;
  final String dbName = 'tasks';

  final BehaviorSubject<List<TaskVM>> _tasks = BehaviorSubject.seeded([]);
  Stream<List<TaskVM>> get tasks => _tasks.stream;

  TaskBloc() {
    initDB().then((value) {
      taskDB = value;
      getTasks();
    });

    // getMockTasks();
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), '$dbName.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        '''
        CREATE TABLE $dbName(
            id INTEGER PRIMARY KEY, 
            completed INTEGER, 
            text TEXT
          )
        ''',
      );
    });
  }

  getMockTasks() {
    _tasks.add(taskMockList0);
  }

// db
  Future<List<TaskVM>> getTasks({bool updateStream = true}) async {
    final List<Map<String, dynamic>> data = await taskDB.query(dbName);

    if (data.isEmpty) {
      return [];
    }

    List<TaskVM> tasks = List.generate(data.length, (i) {
      return TaskVM(
        id: data[i]['id'],
        completed: data[i]['completed'] == 0 ? false : true,
        text: data[i]['text'],
      );
    });

    tasks.sort((a, b) => -a.id.compareTo(b.id));

    if (updateStream) {
      _tasks.add(tasks);
    }
    return tasks;
  }

  Future<void> insertTask(TaskVM task, {bool updateStream = true}) async {
    await taskDB.insert(
      dbName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (updateStream) {
      getTasks();
    }
  }

  Future<void> updateTask(TaskVM task, {bool updateStream = true}) async {
    await taskDB.update(
      dbName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );

    if (updateStream) {
      getTasks();
    }
  }

  Future<void> deleteTask(TaskVM task, {bool updateStream = true}) async {
    await taskDB.delete(
      dbName,
      where: 'id = ?',
      whereArgs: [task.id],
    );

    if (updateStream) {
      getTasks();
    }
  }
  // db end

  toggleTask(TaskVM task) {
    // List<TaskVM> tasks = _tasks.value;
    // tasks.removeWhere((element) => element.id == task.id);
    // tasks.add(task.copyWith(completed: !task.completed));
    // _tasks.add(tasks);

    updateTask(task.copyWith(completed: !task.completed));
  }

  addTask(TaskVM task) {
    List<TaskVM> tasks = _tasks.value;
    tasks.insert(0, task);
    _tasks.add(tasks);
  }

  editTask(TaskVM task, String text) async {
    // try {
    //   List<TaskVM> tasks = _tasks.value;
    //   if (text.isEmpty) {
    //     tasks.removeWhere((element) => element.id == task.id);
    //   } else {
    //     int index = tasks.indexWhere((element) => element.id == task.id);
    //     tasks[index] = task.copyWith(text: text);
    //   }

    //   _tasks.add(tasks);
    // } catch (e) {
    //   print('error in editTask: $text');
    // }

    List<TaskVM> tasks = await getTasks(updateStream: false);
    if (tasks.where((element) => element.id == task.id).isEmpty &&
        text.isNotEmpty) {
      insertTask(task.copyWith(text: text));
    } else {
      if (text.isEmpty) {
        deleteTask(task);
      } else {
        updateTask(task.copyWith(text: text));
      }
    }
  }

  removeTask(TaskVM task) {
    // List<TaskVM> tasks = _tasks.value;
    // tasks.removeWhere((element) => element.id == task.id);
    // _tasks.add(tasks);

    deleteTask(task);
  }

  clearCompletedTasks() {
    List<TaskVM> tasks = _tasks.value;
    tasks = tasks.where((element) => element.completed).toList();

    for (TaskVM task in tasks) {
      deleteTask(task, updateStream: false);
    }
    getTasks();
  }
}
