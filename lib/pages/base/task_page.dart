import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/styles/colors.dart';
import 'package:what_to_do/widgets/task_box.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectBloc projectBloc = context.read<ProjectBloc>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
          .copyWith(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PendingTasks(),
          // const SizedBox(height: 18),
          // const CompletedTasks(),
          StreamBuilder<List<ProjectVM>>(
              stream: projectBloc.projects,
              builder: (context, snapshot) {
                List<ProjectVM> projects = snapshot.data ?? [];

                return Column(
                  children:
                      projects.map((e) => ProjectTasks(project: e)).toList(),
                );
              }),
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

    addTask() {
      taskBloc.setPickedDate(null);

      showDialog(
          context: context,
          builder: (context) {
            TextEditingController taskController = TextEditingController();

            return SimpleDialog(
              backgroundColor: Theme.of(context).cardColor,
              elevation: 0,
              contentPadding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Task',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xff424242),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: taskController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Task',
                  ),
                  style: const TextStyle(height: 1),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                    onTap: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2200),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: Theme.of(context).colorScheme,
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .onPrimary, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => taskBloc.setPickedDate(value));
                    },
                    child: StreamBuilder<DateTime?>(
                        stream: taskBloc.pickedDate,
                        builder: (context, snapshot) {
                          DateTime? pickedDate = snapshot.data;

                          return Row(
                            children: [
                              Image.asset('assets/icons/projects.png',
                                  width: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              const SizedBox(width: 6),
                              Text(
                                pickedDate == null
                                    ? 'Add date'
                                    : DateFormat('MMMM d, E')
                                        .format(pickedDate),
                                style: TextStyle(
                                  height: 1,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              if (pickedDate != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: GestureDetector(
                                    onTap: () {
                                      taskBloc.setPickedDate(null);
                                    },
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: OGColors.gray030,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 12,
                                        color: OGColors.white,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          );
                        })),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      taskBloc.addTask(TaskVM(
                        id: DateTime.now().millisecondsSinceEpoch,
                        index: taskBloc.tasksLength,
                        completed: false,
                        text: taskController.text,
                        date: taskBloc.pickedDateValue,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        fontSize: 14,
                        height: 1,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ],
            );
          });
    }

    return StreamBuilder<bool>(
        stream: taskBloc.foldTodo,
        builder: (context, snapshot) {
          bool foldTodo = snapshot.data ?? false;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      taskBloc.setFoldTodo(!foldTodo);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/${foldTodo ? 'fold' : 'unfold'}.png',
                          width: 16,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Todo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  foldTodo
                      ? const SizedBox(height: 32)
                      : SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              addTask();

                              // FocusNode focusNode = FocusNode();
                              // taskBloc.addTask(TaskVM(
                              //   id: DateTime.now().millisecondsSinceEpoch,
                              //   index: taskBloc.tasksLength,
                              //   completed: false,
                              //   text: '',
                              //   focusNode: focusNode,
                              // ));
                              // focusNode.requestFocus();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_box,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Add Task',
                                  style: TextStyle(
                                      fontSize: 12,
                                      height: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 6),
              if (!foldTodo)
                StreamBuilder(
                    stream: taskBloc.tasks,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      List<TaskVM> tasks = snapshot.data!;

                      // List<TaskVM> pendingTasks =
                      //     tasks.where((element) => !element.completed).toList();
                      // List<TaskVM> completedTasks =
                      //     tasks.where((element) => element.completed).toList();

                      // tasks = pendingTasks + completedTasks;

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

                      return ReorderableListView.builder(
                        key: const Key('task_reorder'),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        buildDefaultDragHandles: false,
                        proxyDecorator: proxyDecorator,
                        onReorderStart: (index) {
                          HapticFeedback.mediumImpact();
                          taskBloc.setReordering(index);
                        },
                        onReorderEnd: (index) {
                          HapticFeedback.lightImpact();
                          taskBloc.setReordering(null);
                        },
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > tasks.length) newIndex = tasks.length;
                          if (oldIndex < newIndex) newIndex--;

                          taskBloc.reorderTask(
                              tasks[oldIndex], oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          TaskVM task = tasks[index];

                          return Padding(
                            key: Key('task_page${task.id}_$index'),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: StreamBuilder<List>(
                                stream: Rx.combineLatestList([
                                  taskBloc.reorderingProject,
                                  taskBloc.reordering
                                ]),
                                builder: (context, snapshot) {
                                  bool isReordering =
                                      snapshot.data?[0] == null &&
                                          snapshot.data?[1] == index;

                                  return TaskBox(
                                    task: task,
                                    toggle: () => taskBloc.toggleTask(task),
                                    edit: (String text, DateTime? date) =>
                                        taskBloc.editTask(task, text, date),
                                    remove: () => taskBloc.removeTask(task),
                                    reordering: isReordering,
                                  );
                                }),
                          );
                        },
                        itemCount: tasks.length,
                      );
                    }),
              const SizedBox(height: 18),
            ],
          );
        });
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
                          toggle: () => taskBloc.toggleTask(task),
                          edit: (String text, DateTime? date) =>
                              taskBloc.editTask(task, text, date),
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

Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      return Material(
        elevation: 0,
        color: Colors.transparent,
        child: child,
      );
    },
    child: child,
  );
}

class ProjectTasks extends StatelessWidget {
  final ProjectVM project;
  const ProjectTasks({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    ProjectBloc projectBloc = context.read<ProjectBloc>();
    TaskBloc taskBloc = context.read<TaskBloc>();

    addProjectTask() {
      projectBloc.setPickedDate(null);

      showDialog(
          context: context,
          builder: (context) {
            TextEditingController taskController = TextEditingController();

            return SimpleDialog(
              backgroundColor: Theme.of(context).cardColor,
              elevation: 0,
              contentPadding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Task',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xff424242),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: taskController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Task',
                  ),
                  style: const TextStyle(height: 1),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                    onTap: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2200),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: Theme.of(context).colorScheme,
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .onPrimary, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => projectBloc.setPickedDate(value));
                    },
                    child: StreamBuilder<DateTime?>(
                        stream: projectBloc.pickedDate,
                        builder: (context, snapshot) {
                          DateTime? pickedDate = snapshot.data;

                          return Row(
                            children: [
                              Image.asset('assets/icons/projects.png',
                                  width: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              const SizedBox(width: 6),
                              Text(
                                pickedDate == null
                                    ? 'Add date'
                                    : DateFormat('MMMM d, E')
                                        .format(pickedDate),
                                style: TextStyle(
                                  height: 1,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              if (pickedDate != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: GestureDetector(
                                    onTap: () {
                                      projectBloc.setPickedDate(null);
                                    },
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: OGColors.gray030,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 12,
                                        color: OGColors.white,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          );
                        })),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      projectBloc.addTask(
                          project,
                          TaskVM(
                            id: DateTime.now().millisecondsSinceEpoch,
                            index: project.tasks.length,
                            completed: false,
                            text: taskController.text,
                            date: projectBloc.pickedDateValue,
                          ));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        fontSize: 14,
                        height: 1,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ],
            );
          });
    }

    List<TaskVM> tasks = project.tasks;

    // List<TaskVM> pendingTasks =
    //     tasks.where((element) => !element.completed).toList();
    // List<TaskVM> completedTasks =
    //     tasks.where((element) => element.completed).toList();

    // tasks = pendingTasks + completedTasks;

    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<int>>(
        stream: taskBloc.foldProjects,
        builder: (context, snapshot) {
          List<int> foldProjects = snapshot.data ?? [];
          bool isFold = foldProjects.contains(project.id);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        taskBloc.setFoldProjects(project.id);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/${isFold ? 'fold' : 'unfold'}.png',
                            width: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              project.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 4),
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        addProjectTask();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_box,
                            size: 16,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Add Task',
                            style: TextStyle(
                                fontSize: 12,
                                height: 1,
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (!isFold)
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  proxyDecorator: proxyDecorator,
                  onReorderStart: (index) {
                    HapticFeedback.mediumImpact();
                    taskBloc.setReordering(index);
                    taskBloc.setReorderingProject(project.id);
                  },
                  onReorderEnd: (index) {
                    HapticFeedback.lightImpact();
                    taskBloc.setReordering(null);
                    taskBloc.setReorderingProject(null);
                  },
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > tasks.length) newIndex = tasks.length;
                    if (oldIndex < newIndex) newIndex--;

                    projectBloc.reorderTask(
                        project, tasks[oldIndex], oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    TaskVM task = tasks[index];

                    return Padding(
                      key: Key('task_page_${project.id}_${task.id}_$index'),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: StreamBuilder<List>(
                          stream: Rx.combineLatestList([
                            taskBloc.reorderingProject,
                            taskBloc.reordering
                          ]),
                          builder: (context, snapshot) {
                            bool isReordering =
                                snapshot.data?[0] == project.id &&
                                    snapshot.data?[1] == index;

                            return TaskBox(
                              task: task,
                              toggle: () =>
                                  projectBloc.toggleTask(project, task),
                              edit: (String text, DateTime? date) => projectBloc
                                  .editTask(project, task, text, date),
                              remove: () =>
                                  projectBloc.removeTask(project, task),
                              reordering: isReordering,
                            );
                          }),
                    );
                  },
                  itemCount: tasks.length,
                ),
              const SizedBox(height: 18),
            ],
          );
        });
  }
}
