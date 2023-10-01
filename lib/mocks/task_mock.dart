import 'package:what_to_do/models/task_model.dart';

TaskVM taskMock0 =
    TaskVM(id: 0, completed: false, text: 'This is pending task mock 0');
TaskVM taskMock1 =
    TaskVM(id: 1, completed: true, text: 'This is completed task mock 1');
TaskVM taskMock2 =
    TaskVM(id: 2, completed: false, text: 'This is pending task mock 2');
TaskVM taskMock3 =
    TaskVM(id: 3, completed: false, text: 'This is pending task mock 3');
TaskVM taskMock4 =
    TaskVM(id: 4, completed: true, text: 'This is completed task mock 4');
TaskVM taskMock5 = TaskVM(
    id: 5,
    completed: false,
    text: 'This is completed task mock 5.\nAnd this is a two liner.');

List<TaskVM> taskMockList0 = [
  taskMock0,
  taskMock1,
  taskMock2,
  taskMock3,
  taskMock4,
  taskMock5,
];
