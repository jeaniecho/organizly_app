import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:what_to_do/mocks/project_mock.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/models/task_model.dart';

class ProjectBloc {
  final BehaviorSubject<List<ProjectVM>> _projects = BehaviorSubject.seeded([]);
  Stream<List<ProjectVM>> get projects => _projects.stream;

  final BehaviorSubject<int> _pageIndex = BehaviorSubject.seeded(0);
  Stream<int> get pageIndex => _pageIndex.stream;
  Function get setPageIndex => _pageIndex.add;

  final PageController pageController = PageController(viewportFraction: 0.75);

  ProjectBloc() {
    getMockProjects();
  }

  getMockProjects() {
    _projects.add(projectMockList0);
  }

  movePage(int index) {
    _pageIndex.add(index);
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  addProject(ProjectVM project) {
    List<ProjectVM> projects = _projects.value;
    projects.add(project);
    _projects.add(projects);

    if (projects.length > 1) {
      movePage(projects.length - 1);
    }
  }

  editProject(ProjectVM project, String title) {
    List<ProjectVM> projects = _projects.value;

    int index = projects.indexWhere((element) => element.id == project.id);
    projects[index] = project.copyWith(title: title);

    _projects.add(projects);
  }

  removeProject(ProjectVM project) {
    List<ProjectVM> projects = _projects.value;
    projects.removeWhere((element) => element.id == project.id);
    _projects.add(projects);

    if (_pageIndex.value >= projects.length) {
      movePage(projects.length - 1);
    }
  }

  addTask(ProjectVM project, TaskVM task) {
    List<ProjectVM> projects = _projects.value;

    int index = projects.indexWhere((element) => element.id == project.id);
    projects[index] = project.copyWith(tasks: [task, ...project.tasks]);

    _projects.add(projects);
  }

  toggleTask(ProjectVM project, TaskVM task) {
    List<ProjectVM> projects = _projects.value;

    int index = projects.indexWhere((element) => element.id == project.id);
    List<TaskVM> tasks = project.tasks;
    tasks.removeWhere((element) => element.id == task.id);
    tasks.add(task.copyWith(completed: !task.completed));
    projects[index] = project.copyWith(tasks: tasks);

    _projects.add(projects);
  }

  editTask(ProjectVM project, TaskVM task, String text) {
    List<ProjectVM> projects = _projects.value;

    int index = projects.indexWhere((element) => element.id == project.id);
    List<TaskVM> tasks = project.tasks;

    if (text.isEmpty) {
      tasks.removeWhere((element) => element.id == task.id);
    } else {
      int index = tasks.indexWhere((element) => element.id == task.id);
      tasks[index] = task.copyWith(text: text);
    }
    projects[index] = project.copyWith(tasks: tasks);

    _projects.add(projects);
  }

  removeTask(ProjectVM project, TaskVM task) {
    List<ProjectVM> projects = _projects.value;

    int index = projects.indexWhere((element) => element.id == project.id);
    List<TaskVM> tasks = project.tasks;
    tasks.removeWhere((element) => element.id == task.id);
    projects[index] = project.copyWith(tasks: tasks);

    _projects.add(projects);
  }
}
