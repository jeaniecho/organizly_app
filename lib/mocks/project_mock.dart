import 'package:what_to_do/mocks/task_mock.dart';
import 'package:what_to_do/models/project_model.dart';

ProjectVM projectMock0 = ProjectVM(
  id: 0,
  index: 0,
  title: 'Project 0',
  tasks: projectTaskMockList0,
);
ProjectVM projectMock1 = ProjectVM(
  id: 1,
  index: 1,
  title: 'Project 1',
  tasks: [],
);
ProjectVM projectMock2 = ProjectVM(
  id: 2,
  index: 2,
  title: 'Project 2',
  tasks: [],
);
ProjectVM projectMock3 = ProjectVM(
  id: 3,
  index: 3,
  title: 'Project3',
  tasks: [],
);

List<ProjectVM> projectMockList0 = [
  projectMock0,
  projectMock1,
  projectMock2,
  projectMock3
];
