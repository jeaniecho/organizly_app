import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/pages/pages.dart';
import 'package:what_to_do/widgets/project_box.dart';
import 'package:what_to_do/widgets/task_box.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectBloc projectBloc = context.read<ProjectBloc>();

    addProject() {
      TextEditingController projectController = TextEditingController();

      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              backgroundColor: const Color(0xffFCFDFF),
              elevation: 0,
              contentPadding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Project',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff424242)),
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
                  decoration: const InputDecoration(
                    hintText: 'Project Name',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (projectController.text.isNotEmpty) {
                      projectBloc.addProject(ProjectVM(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: projectController.text,
                        tasks: [],
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(
                        fontSize: 14, height: 1, color: Color(0xff39A0FF)),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_box,
                        size: 18,
                        color: Color(0xff39A0FF),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Add Project',
                        style: TextStyle(
                            fontSize: 14, height: 1, color: Color(0xff39A0FF)),
                      ),
                    ],
                  ),
                ),
              ),
            );

            // return const Center(
            //   child: Text(
            //     'Add projects',
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // );
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
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_box,
                                size: 16,
                                color: Color(0xff39A0FF),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Add Project',
                                style: TextStyle(
                                    fontSize: 12,
                                    height: 1,
                                    color: Color(0xff39A0FF)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 124,
                  child: PageView.builder(
                    controller: projectBloc.pageController,
                    onPageChanged: (value) {
                      projectBloc.movePage(value);
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
                            const SizedBox(height: 24),
                            CompletedProjectTasks(project: projects[pageIndex]),
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

    // List<TaskVM> tasks =
    //     project.tasks.where((element) => !element.completed).toList();

    return StreamBuilder<List<TaskVM>>(
        stream: projectBloc.tasks,
        builder: (context, snapshot) {
          List<TaskVM> tasks = snapshot.data ?? [];

          tasks = tasks.where((element) => !element.completed).toList();

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
                        FocusNode focusNode = FocusNode();
                        projectBloc
                            .addTask(
                                project,
                                TaskVM(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  index: tasks.length,
                                  completed: false,
                                  text: '',
                                  focusNode: focusNode,
                                ))
                            .then((value) => focusNode.requestFocus());
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
                                fontSize: 12,
                                height: 1,
                                color: Color(0xff39A0FF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      proxyDecorator: proxyDecorator,
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > tasks.length) newIndex = tasks.length;
                        if (oldIndex < newIndex) newIndex--;

                        projectBloc.reorderTask(
                            project, tasks[oldIndex], oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        TaskVM task = tasks[index];

                        return TaskBox(
                          key: Key('project_page${task.id}'),
                          task: task,
                          boxWidth: 100,
                          toggle: () => projectBloc.toggleTask(project, task),
                          submit: (String text) =>
                              projectBloc.editTask(project, task, text),
                          remove: () => projectBloc.removeTask(project, task),
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
                    boxWidth: 100,
                    toggle: () => projectBloc.toggleTask(project, task),
                    submit: (String text) =>
                        projectBloc.editTask(project, task, text),
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
