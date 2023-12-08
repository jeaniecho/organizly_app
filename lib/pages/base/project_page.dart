import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/pages/pages.dart';
import 'package:what_to_do/styles/colors.dart';
import 'package:what_to_do/widgets/project_box.dart';
import 'package:what_to_do/widgets/task_box.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectBloc projectBloc = context.read<ProjectBloc>();

    addProject() {
      TextEditingController projectController = TextEditingController();

      projectBloc.setPickedDate(null);

      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              backgroundColor: Theme.of(context).cardColor,
              elevation: 0,
              contentPadding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Project',
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
                  controller: projectController,
                  autofocus: true,
                  style: const TextStyle(height: 1),
                  decoration: const InputDecoration(
                    hintText: 'Project Name',
                  ),
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
                    if (projectController.text.isNotEmpty) {
                      projectBloc.addProject(ProjectVM(
                        id: DateTime.now().millisecondsSinceEpoch,
                        index: projectBloc.projectsLength,
                        title: projectController.text,
                        tasks: [],
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

    return StreamBuilder<List>(
        stream:
            Rx.combineLatestList([projectBloc.projects, projectBloc.pageIndex]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ProjectVM> projects = snapshot.data![0];

          int pageIndex = snapshot.data![1] ?? 0;

          if (projects.isEmpty) {
            return Center(
              child: SizedBox(
                width: 140,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    addProject();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_box,
                        size: 18,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add Project',
                        style: TextStyle(
                            fontSize: 14,
                            height: 1,
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            addProject();
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
                                'Add Project',
                                style: TextStyle(
                                    fontSize: 12,
                                    height: 1,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: PageView.builder(
                    controller: projectBloc.pageController,
                    onPageChanged: (value) {
                      projectBloc.movePage(value, false);
                    },
                    itemBuilder: (context, index) {
                      ProjectVM project = projects[index];
                      bool isSelected = pageIndex == index;

                      List<TaskVM> pendingTasks = project.tasks
                          .where((element) => !element.completed)
                          .toList();
                      List<TaskVM> completedTasks = project.tasks
                          .where((element) => element.completed)
                          .toList();

                      return ProjectBox(
                        project: project,
                        isSelected: isSelected,
                        pendingTasks: pendingTasks.length,
                        completedTasks: completedTasks.length,
                        edit: (title) =>
                            projectBloc.editProject(project, title),
                        editDate: (date) =>
                            projectBloc.editProjectDate(project, date),
                        toFirst: () => projectBloc.projectToFirst(project),
                        remove: () => projectBloc.removeProject(project),
                      );
                    },
                    itemCount: projects.length,
                  ),
                ),
                const SizedBox(height: 12),
                StreamBuilder<int>(
                    stream: projectBloc.pageIndex,
                    builder: (context, snapshot) {
                      int pageIndex = snapshot.data ?? 0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            PendingProjectTasks(project: projects[pageIndex]),
                            // const SizedBox(height: 18),
                            // CompletedProjectTasks(project: projects[pageIndex]),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }
}

class PendingProjectTasks extends StatelessWidget {
  final ProjectVM project;
  const PendingProjectTasks({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    ProjectBloc projectBloc = context.read<ProjectBloc>();

    addTask() {
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

    // List<TaskVM> tasks =
    //     project.tasks.where((element) => !element.completed).toList();

    return StreamBuilder<List<TaskVM>>(
        stream: projectBloc.tasks,
        builder: (context, snapshot) {
          List<TaskVM> tasks = snapshot.data ?? [];

          // tasks = tasks.where((element) => !element.completed).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tasks',
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
                        addTask();
                        // FocusNode focusNode = FocusNode();
                        // projectBloc
                        //     .addTask(
                        //         project,
                        //         TaskVM(
                        //           id: DateTime.now().millisecondsSinceEpoch,
                        //           index: tasks.length,
                        //           completed: false,
                        //           text: '',
                        //           focusNode: focusNode,
                        //         ))
                        //     .then((value) => focusNode.requestFocus());
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
              tasks.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          project.tasks.isEmpty
                              ? 'Add tasks'
                              : 'Completed all tasks',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : ReorderableListView.builder(
                      key: Key('project_reorder_${project.id}'),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      proxyDecorator: proxyDecorator,
                      onReorderStart: (index) {
                        HapticFeedback.mediumImpact();
                        projectBloc.setReordering(index);
                      },
                      onReorderEnd: (index) {
                        HapticFeedback.lightImpact();
                        projectBloc.setReordering(null);
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
                          key: Key(
                              'project_page_${project.id}_${task.id}_$index'),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: StreamBuilder<int?>(
                              stream: projectBloc.reordering,
                              builder: (context, snapshot) {
                                bool isReordering = snapshot.data == index;

                                return TaskBox(
                                  task: task,
                                  toggle: () =>
                                      projectBloc.toggleTask(project, task),
                                  edit: (String text, DateTime? date) =>
                                      projectBloc.editTask(
                                          project, task, text, date),
                                  remove: () =>
                                      projectBloc.removeTask(project, task),
                                  reordering: isReordering,
                                );
                              }),
                        );
                      },
                      itemCount: tasks.length,
                    )
            ],
          );
        });
  }
}

class CompletedProjectTasks extends StatelessWidget {
  final ProjectVM project;
  const CompletedProjectTasks({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    ProjectBloc projectBloc = context.read<ProjectBloc>();

    List<TaskVM> tasks =
        project.tasks.where((element) => element.completed).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Completed',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        tasks.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
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
                    toggle: () => projectBloc.toggleTask(project, task),
                    edit: (String text, DateTime? date) =>
                        projectBloc.editTask(project, task, text, date),
                    remove: () => projectBloc.removeTask(project, task),
                  );
                }),
                separatorBuilder: ((context, index) {
                  return const SizedBox(height: 12);
                }),
                itemCount: tasks.length,
              )
      ],
    );
  }
}
