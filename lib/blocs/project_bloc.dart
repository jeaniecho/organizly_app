import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:what_to_do/mocks/project_mock.dart';
import 'package:what_to_do/models/project_model.dart';

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

  addProject(ProjectVM project) {
    List<ProjectVM> projects = _projects.value;
    projects.add(project);
    _projects.add(projects);
    _pageIndex.add(projects.length - 1);
    pageController.animateToPage(projects.length - 1,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  editProject(ProjectVM project, String title) {
    List<ProjectVM> projects = _projects.value;

    int index = projects.indexWhere((element) => element.id == project.id);
    projects[index] = project.copyWith(title: title);

    _projects.add(projects);
  }
}
