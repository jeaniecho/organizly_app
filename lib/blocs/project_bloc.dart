import 'dart:convert';

import 'package:flutter/material.dart';
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

  final BehaviorSubject<int> _pageIndex = BehaviorSubject.seeded(0);
  Stream<int> get pageIndex => _pageIndex.stream;
  Function get setPageIndex => _pageIndex.add;

  final PageController pageController = PageController(viewportFraction: 0.75);

  ProjectBloc() {
    initDB().then((value) {
      projectDB = value;
      getProjects();
    });

    // getMockProjects();
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), '$dbName.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        '''
        CREATE TABLE $dbName(
            id INTEGER PRIMARY KEY, 
            title TEXT,
            tasks TEXT
          )
        ''',
      );
    });
  }

  getMockProjects() {
    _projects.add(projectMockList0);
  }

  // db
  Future<List<ProjectVM>> getProjects({bool updateStream = true}) async {
    final List<Map<String, dynamic>> data = await projectDB.query(dbName);

    List<ProjectVM> projects = List.generate(data.length, (i) {
      return ProjectVM(
        id: data[i]['id'],
        title: data[i]['title'],
        tasks: (jsonDecode(data[i]['tasks']) as List)
            .map((e) => TaskVM(
                  id: e['id'],
                  completed: e['completed'] == 0 ? false : true,
                  text: e['text'],
                ))
            .toList(),
      );
    });

    if (updateStream) {
      _projects.add(projects);
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
      getProjects();
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
      getProjects();
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
      getProjects();
    }
  }
  // db end

  movePage(int index) {
    _pageIndex.add(index);
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  addProject(ProjectVM project) {
    // List<ProjectVM> projects = _projects.value;
    // projects.add(project);
    // _projects.add(projects);

    insertProject(project).then((value) {
      List<ProjectVM> projects = _projects.value;

      if (projects.length > 1) {
        movePage(projects.length - 1);
      }
    });
  }

  editProject(ProjectVM project, String title) {
    // List<ProjectVM> projects = _projects.value;

    // int index = projects.indexWhere((element) => element.id == project.id);
    // projects[index] = project.copyWith(title: title);

    // _projects.add(projects);

    updateProject(project.copyWith(title: title));
  }

  removeProject(ProjectVM project) {
    // List<ProjectVM> projects = _projects.value;
    // projects.removeWhere((element) => element.id == project.id);
    // _projects.add(projects);

    deleteProject(project, updateStream: false).then((value) {
      List<ProjectVM> projects = _projects.value;

      if (_pageIndex.value >= projects.length - 1 && projects.length > 1) {
        movePage(projects.length - 2);
      }
      getProjects();
    });
  }

  addTask(ProjectVM project, TaskVM task) {
    // List<ProjectVM> projects = _projects.value;

    // int index = projects.indexWhere((element) => element.id == project.id);
    // projects[index] = project.copyWith(tasks: [task, ...project.tasks]);

    // _projects.add(projects);

    updateProject(project.copyWith(tasks: [task, ...project.tasks]));
  }

  toggleTask(ProjectVM project, TaskVM task) {
    // List<ProjectVM> projects = _projects.value;

    // int index = projects.indexWhere((element) => element.id == project.id);
    List<TaskVM> tasks = project.tasks;
    tasks.removeWhere((element) => element.id == task.id);
    tasks.add(task.copyWith(completed: !task.completed));
    // projects[index] = project.copyWith(tasks: tasks);

    // _projects.add(projects);

    updateProject(project.copyWith(tasks: tasks));
  }

  editTask(ProjectVM project, TaskVM task, String text) {
    // List<ProjectVM> projects = _projects.value;

    // int index = projects.indexWhere((element) => element.id == project.id);
    List<TaskVM> tasks = project.tasks;

    if (text.isEmpty) {
      tasks.removeWhere((element) => element.id == task.id);
    } else {
      int index = tasks.indexWhere((element) => element.id == task.id);
      tasks[index] = task.copyWith(text: text);
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

    updateProject(project.copyWith(tasks: tasks));
  }
}
