import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/widgets/project_box.dart';
import 'package:what_to_do/widgets/task_box.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectBloc projectBloc = context.read<ProjectBloc>();

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
            return const Center(
              child: Text(
                'Add projects',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 124,
                  child: PageView.builder(
                    controller: projectBloc.pageController,
                    onPageChanged: (value) {
                      projectBloc.setPageIndex(value);
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

    List<TaskVM> tasks =
        project.tasks.where((element) => !element.completed).toList();

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
                  projectBloc.addTask(
                      project,
                      TaskVM(
                        id: DateTime.now().millisecondsSinceEpoch,
                        completed: false,
                        text: '',
                        focusNode: focusNode,
                      ));
                  focusNode.requestFocus();
                },
                child: const Text('Add'),
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
                    project.tasks.isEmpty ? 'Add tasks' : 'Completed all tasks',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  TaskVM task = tasks[index];

                  return TaskBox(
                    task: task,
                    boxWidth: 100,
                    toggle: () => projectBloc.toggleTask(project, task),
                    edit: (String text) =>
                        projectBloc.editTask(project, task, text),
                    remove: () => projectBloc.removeTask(project, task),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
                itemCount: tasks.length,
              )
      ],
    );
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
                    edit: (String text) =>
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
