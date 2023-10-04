import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/widgets/task_box.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
          .copyWith(bottom: 24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PendingTasks(),
          SizedBox(height: 24),
          CompletedTasks(),
        ],
      ),
    );
  }
}

class PendingTasks extends StatelessWidget {
  const PendingTasks({super.key});

  @override
  Widget build(BuildContext context) {
    TaskBloc taskBloc = context.read<TaskBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Todo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  FocusNode focusNode = FocusNode();
                  taskBloc.addTask(TaskVM(
                    id: DateTime.now().millisecondsSinceEpoch,
                    completed: false,
                    text: '',
                    focusNode: focusNode,
                  ));
                  focusNode.requestFocus();
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.add_box,
                      size: 16,
                      color: Color(0xff39A0FF),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add Task',
                      style: TextStyle(
                          fontSize: 12, height: 1, color: Color(0xff39A0FF)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder(
            stream: taskBloc.tasks,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<TaskVM> tasks = snapshot.data!
                  .where((element) => !element.completed)
                  .toList();

              if (tasks.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'No tasks',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  TaskVM task = tasks[index];

                  return TaskBox(
                    task: task,
                    boxWidth: 100,
                    toggle: () => taskBloc.toggleTask(task),
                    submit: (String text) => taskBloc.editTask(task, text),
                    remove: () => taskBloc.removeTask(task),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
                itemCount: tasks.length,
              );
            })
      ],
    );
  }
}

class CompletedTasks extends StatelessWidget {
  const CompletedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    TaskBloc taskBloc = context.read<TaskBloc>();

    return StreamBuilder<List<TaskVM>>(
        stream: taskBloc.tasks,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<TaskVM> tasks =
              snapshot.data!.where((element) => element.completed).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // if (tasks.isNotEmpty)
                  //   SizedBox(
                  //     height: 32,
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         HapticFeedback.selectionClick();
                  //         taskBloc.clearCompletedTasks();
                  //       },
                  //       child: const Row(
                  //         children: [
                  //           Icon(
                  //             Icons.remove_circle,
                  //             size: 16,
                  //             color: Color(0xff39A0FF),
                  //           ),
                  //           SizedBox(width: 4),
                  //           Text(
                  //             'Clear',
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 height: 1,
                  //                 color: Color(0xff39A0FF)),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
              const SizedBox(height: 12),
              tasks.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Complete tasks',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        TaskVM task = tasks[index];

                        return TaskBox(
                          task: task,
                          boxWidth: 100,
                          toggle: () => taskBloc.toggleTask(task),
                          submit: (String text) =>
                              taskBloc.editTask(task, text),
                          remove: () => taskBloc.removeTask(task),
                        );
                      }),
                      separatorBuilder: ((context, index) {
                        return const SizedBox(height: 12);
                      }),
                      itemCount: tasks.length,
                    )
            ],
          );
        });
  }
}
