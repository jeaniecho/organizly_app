import 'package:flutter/services.dart';
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
  int get tasksLength => _tasks.value.length;

  final BehaviorSubject<int?> _reordering = BehaviorSubject.seeded(null);
  Stream<int?> get reordering => _reordering.stream;
  Function get setReordering => _reordering.add;

  final BehaviorSubject<int?> _reorderingProject = BehaviorSubject.seeded(null);
  Stream<int?> get reorderingProject => _reorderingProject.stream;
  Function get setReorderingProject => _reorderingProject.add;

  final BehaviorSubject<bool> _foldTodo = BehaviorSubject.seeded(false);
  Stream<bool> get foldTodo => _foldTodo.stream;
  Function get setFoldTodo => _foldTodo.add;

  final BehaviorSubject<List<int>> _foldProjects = BehaviorSubject.seeded([]);
  Stream<List<int>> get foldProjects => _foldProjects.stream;

  final BehaviorSubject<DateTime?> _pickedDate = BehaviorSubject.seeded(null);
  Stream<DateTime?> get pickedDate => _pickedDate.stream;
  Function get setPickedDate => _pickedDate.add;
  DateTime? get pickedDateValue => _pickedDate.value;

  TaskBloc() {
    initDB().then((value) {
      taskDB = value;
      getTasks();
    });

    // getMockTasks();
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), '$dbName.db');
    return await openDatabase(
      path,
      version: 6,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $dbName(
              id INTEGER PRIMARY KEY,
              task_index INTEGER,
              completed INTEGER,
              text TEXT,
              date INTEGER
            )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          db.execute('ALTER TABLE $dbName ADD COLUMN date INTEGER');
        }
      },
    );
  }

  getMockTasks() {
    _tasks.add(taskMockList0);
  }

// db
  Future<List<TaskVM>> getTasks({bool updateStream = true}) async {
    final List<Map<String, dynamic>> data = await taskDB.query(dbName);

    List<TaskVM> tasks = List.generate(data.length, (i) {
      return TaskVM(
          id: data[i]['id'],
          index: data[i]['task_index'],
          completed: data[i]['completed'] == 0 ? false : true,
          text: data[i]['text'],
          date: data[i]['date'] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(data[i]['date']));
    });

    tasks.sort((a, b) => -a.index.compareTo(b.index));

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

  Future<void> deleteAllTasks({bool updateStream = true}) async {
    await taskDB.delete(dbName);

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

    HapticFeedback.selectionClick();
    updateTask(task.copyWith(completed: !task.completed));
  }

  addTask(TaskVM task) {
    // List<TaskVM> tasks = _tasks.value;
    // tasks.insert(0, task);
    // _tasks.add(tasks);
    insertTask(task, updateStream: true);
  }

  editTask(TaskVM task, String text) async {
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

  reorderTask(TaskVM task, int oldIndex, int newIndex) async {
    List<TaskVM> tasks = _tasks.value;

    tasks.removeAt(oldIndex);
    if (newIndex >= tasks.length) {
      tasks.add(task);
    } else {
      tasks.insert(newIndex, task);
    }
    _tasks.add(tasks);

    List<TaskVM> reversed = tasks.reversed.toList();
    await deleteAllTasks(updateStream: false);

    for (int i = 0; i < reversed.length; i++) {
      await insertTask(reversed[i].copyWith(index: i), updateStream: false);
    }

    getTasks();

    // int id_1;
    // int id_2;
    // if (oldIndex < newIndex) {
    //   id_1 = newId - 1;
    //   id_2 = newId + 1;
    // } else {
    //   id_1 = newId + 1;
    //   id_2 = newId - 1;
    // }

    // try {
    //   await taskDB.update(
    //     dbName,
    //     tasks[newIndex].copyWith(id: id_1).toMap(),
    //     where: 'id = ?',
    //     whereArgs: [newId],
    //   );

    //   await taskDB.update(
    //     dbName,
    //     task.copyWith(id: id_2).toMap(),
    //     where: 'id = ?',
    //     whereArgs: [task.id],
    //   );

    //   getTasks();
    // } catch (e) {}
  }

  setFoldProjects(int id) {
    List<int> fp = _foldProjects.value;

    if (fp.contains(id)) {
      fp.remove(id);
    } else {
      fp.add(id);
    }

    _foldProjects.add(fp);
  }
}
