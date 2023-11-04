import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_to_do/mocks/project_mock.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/models/task_model.dart';

class ProjectBloc {
  late final Database projectDB;
  final String dbName = 'projects';

  final BehaviorSubject<List<ProjectVM>> _projects = BehaviorSubject.seeded([]);
  Stream<List<ProjectVM>> get projects => _projects.stream;

  final BehaviorSubject<List<TaskVM>> _tasks = BehaviorSubject.seeded([]);
  Stream<List<TaskVM>> get tasks => _tasks.stream;

  final BehaviorSubject<int> _pageIndex = BehaviorSubject.seeded(0);
  Stream<int> get pageIndex => _pageIndex.stream;
  Function get setPageIndex => _pageIndex.add;

  final BehaviorSubject<int?> _reordering = BehaviorSubject.seeded(null);
  Stream<int?> get reordering => _reordering.stream;
  Function get setReordering => _reordering.add;

  final BehaviorSubject<bool> _jumping = BehaviorSubject.seeded(false);

  final PageController pageController = PageController(viewportFraction: 0.75);

  final BehaviorSubject<DateTime?> _pickedDate = BehaviorSubject.seeded(null);
  Stream<DateTime?> get pickedDate => _pickedDate.stream;
  Function get setPickedDate => _pickedDate.add;
  DateTime? get pickedDateValue => _pickedDate.value;

  ProjectBloc() {
    initDB().then((value) {
      projectDB = value;
      getProjects();
    });

    // getMockProjects();
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), '$dbName.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          '''
        CREATE TABLE $dbName(
            id INTEGER PRIMARY KEY, 
            title TEXT,
            tasks TEXT,
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

  getMockProjects() {
    _projects.add(projectMockList0);
  }

  // db
  Future<List<ProjectVM>> getProjects({bool updateStream = true}) async {
    final List<Map<String, dynamic>> data = await projectDB.query(dbName);

    List<ProjectVM> projects = List.generate(data.length, (i) {
      List<TaskVM> tasks = (jsonDecode(data[i]['tasks']) as List)
          .map((e) => TaskVM(
              id: e['id'],
              index: e['task_index'],
              completed: e['completed'] == 0 ? false : true,
              text: e['text'],
              date: e['date'] == null || e['date'] == 0
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(e['date'])))
          .toList();
      tasks.sort((a, b) => -a.index.compareTo(b.index));

      return ProjectVM(
          id: data[i]['id'],
          title: data[i]['title'],
          tasks: tasks,
          date: data[i]['date'] == null || data[i]['date'] == 0
              ? null
              : DateTime.fromMillisecondsSinceEpoch(data[i]['date']));
    });

    if (updateStream) {
      _projects.add(projects);
      if (projects.isNotEmpty) {
        _tasks.add(projects[_pageIndex.value].tasks);
      }
    }
    return projects;
  }

  Future<void> insertProject(ProjectVM project,
      {bool updateStream = true}) async {
    await projectDB.insert(
      dbName,
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (updateStream) {
      await getProjects();
    }
  }

  Future<void> updateProject(ProjectVM project,
      {bool updateStream = true}) async {
    await projectDB.update(
      dbName,
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );

    if (updateStream) {
      await getProjects();
    }
  }

  Future<void> deleteProject(ProjectVM project,
      {bool updateStream = true}) async {
    await projectDB.delete(
      dbName,
      where: 'id = ?',
      whereArgs: [project.id],
    );

    if (updateStream) {
      await getProjects();
    }
  }
  // db end

  movePage(int index, bool jump) {
    if (!_jumping.value) {
      if (jump) _jumping.add(true);

      _pageIndex.add(index);
      _tasks.add(_projects.value[_pageIndex.value].tasks);
      pageController
          .animateToPage(index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut)
          .then((value) => _jumping.add(false));
    }
  }

  addProject(ProjectVM project) {
    // List<ProjectVM> projects = _projects.value;
    // projects.add(project);
    // _projects.add(projects);

    insertProject(project).then((value) {
      List<ProjectVM> projects = _projects.value;

      if (projects.length > 1) {
        movePage(projects.length - 1, true);
      }
    });
  }

  editProject(ProjectVM project, String title) {
    // List<ProjectVM> projects = _projects.value;

    // int index = projects.indexWhere((element) => element.id == project.id);
    // projects[index] = project.copyWith(title: title);

    // _projects.add(projects);

    updateProject(project.copyWith(title: title, date: project.date));
  }

  editProjectDate(ProjectVM project, DateTime? date) {
    updateProject(project.copyWith(date: date));
  }

  removeProject(ProjectVM project) {
    // List<ProjectVM> projects = _projects.value;
    // projects.removeWhere((element) => element.id == project.id);
    // _projects.add(projects);

    deleteProject(project, updateStream: false).then((value) {
      List<ProjectVM> projects = _projects.value;

      if (_pageIndex.value >= projects.length - 1 && projects.length > 1) {
        movePage(projects.length - 2, true);
      }

      getProjects();
    });
  }

  addTask(ProjectVM project, TaskVM task) async {
    // List<TaskVM> tasks = _tasks.value;
    // tasks.insert(0, task);
    // _tasks.add(tasks);

    updateProject(
        project.copyWith(tasks: [task, ...project.tasks], date: project.date));
  }

  toggleTask(ProjectVM project, TaskVM task) {
    // List<ProjectVM> projects = _projects.value;

    // int index = projects.indexWhere((element) => element.id == project.id);
    List<TaskVM> tasks = project.tasks;
    tasks.removeWhere((element) => element.id == task.id);
    tasks.add(task.copyWith(completed: !task.completed, date: project.date));
    // projects[index] = project.copyWith(tasks: tasks);

    // _projects.add(projects);

    HapticFeedback.selectionClick();
    updateProject(project.copyWith(tasks: tasks));
  }

  editTask(ProjectVM project, TaskVM task, String text, DateTime? date) {
    // List<ProjectVM> projects = _projects.value;

    // int index = projects.indexWhere((element) => element.id == project.id);
    List<TaskVM> tasks = project.tasks;

    if (tasks.where((element) => element.id == task.id).isEmpty &&
        text.isNotEmpty) {
      updateProject(project
          .copyWith(tasks: [task, ...project.tasks], date: project.date));
    } else {
      if (text.isEmpty) {
        tasks.removeWhere((element) => element.id == task.id);
      } else {
        int index = tasks.indexWhere((element) => element.id == task.id);
        tasks[index] = task.copyWith(text: text, date: date);
      }
    }

    // projects[index] = project.copyWith(tasks: tasks);

    // _projects.add(projects);

    updateProject(project.copyWith(tasks: tasks));
  }

  removeTask(ProjectVM project, TaskVM task) {
    // List<ProjectVM> projects = _projects.value;

    // int index = projects.indexWhere((element) => element.id == project.id);
    List<TaskVM> tasks = project.tasks;
    tasks.removeWhere((element) => element.id == task.id);
    // projects[index] = project.copyWith(tasks: tasks);

    // _projects.add(projects);

    updateProject(project.copyWith(tasks: tasks, date: project.date));
  }

  reorderTask(
      ProjectVM project, TaskVM task, int oldIndex, int newIndex) async {
    List<TaskVM> tasks = project.tasks;

    tasks.removeAt(oldIndex);
    if (newIndex > tasks.length) {
      tasks.add(task);
    } else {
      tasks.insert(newIndex, task);
    }
    _tasks.add(tasks);

    List<TaskVM> reversed = tasks.reversed.toList();
    for (int i = 0; i < reversed.length; i++) {
      reversed[i] = reversed[i].copyWith(index: i, date: reversed[i].date);
    }

    updateProject(project.copyWith(tasks: reversed, date: project.date));
  }
}
