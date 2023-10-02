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

TaskVM taskMock6 = TaskVM(id: 6, completed: false, text: 'test mock 6');
TaskVM taskMock7 = TaskVM(id: 7, completed: false, text: 'test mock 7');
TaskVM taskMock8 = TaskVM(id: 8, completed: true, text: 'test mock 8');
TaskVM taskMock9 = TaskVM(id: 9, completed: false, text: 'test mock 9');
TaskVM taskMock10 = TaskVM(id: 10, completed: false, text: 'test mock 10');
TaskVM taskMock11 = TaskVM(id: 11, completed: false, text: 'test mock 11');

List<TaskVM> taskMockList0 = [
  taskMock0,
  taskMock1,
  taskMock2,
  taskMock3,
  taskMock4,
  taskMock5,
];

List<TaskVM> projectTaskMockList0 = [
  taskMock6,
  taskMock7,
  taskMock8,
  taskMock9,
  taskMock10,
  taskMock11,
];
