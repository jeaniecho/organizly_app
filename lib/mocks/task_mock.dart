import 'package:what_to_do/models/task_model.dart';

TaskVM taskMock0 =
    TaskVM(completed: false, text: 'This is pending task mock 0');
TaskVM taskMock1 =
    TaskVM(completed: true, text: 'This is completed task mock 1');
TaskVM taskMock2 =
    TaskVM(completed: false, text: 'This is pending task mock 2');
TaskVM taskMock3 =
    TaskVM(completed: false, text: 'This is pending task mock 3');
TaskVM taskMock4 =
    TaskVM(completed: true, text: 'This is completed task mock 4');

List<TaskVM> taskMockList0 = [
  taskMock0,
  taskMock1,
  taskMock2,
  taskMock3,
  taskMock4,
];
