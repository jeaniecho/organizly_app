import 'package:rxdart/subjects.dart';
import 'package:what_to_do/mocks/project_mock.dart';
import 'package:what_to_do/models/project_model.dart';

class ProjectBloc {
  final BehaviorSubject<List<ProjectVM>> _projects = BehaviorSubject.seeded([]);
  Stream<List<ProjectVM>> get projects => _projects.stream;

  final BehaviorSubject<int> _pageIndex = BehaviorSubject.seeded(0);
  Stream<int> get pageIndex => _pageIndex.stream;
  Function get setPageIndex => _pageIndex.add;

  ProjectBloc() {
    getMockProjects();
  }

  getMockProjects() {
    _projects.add(projectMockList0);
  }
}
