import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/widgets/task_box.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectBloc projectBloc = context.read<ProjectBloc>();

    PageController pageController = PageController(viewportFraction: 0.75);

    return StreamBuilder<List<ProjectVM>>(
        stream: projectBloc.projects,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ProjectVM> projects = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 124,
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) {
                      projectBloc.setPageIndex(value);
                    },
                    itemBuilder: (context, index) {
                      ProjectVM project = projects[index];

                      List<TaskVM> pendingTasks = project.tasks
                          .where((element) => !element.completed)
                          .toList();
                      List<TaskVM> completedTasks = project.tasks
                          .where((element) => element.completed)
                          .toList();

                      return StreamBuilder<int>(
                          stream: projectBloc.pageIndex,
                          builder: (context, snapshot) {
                            int pageIndex = snapshot.data ?? 0;
                            bool isSelected = pageIndex == index;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 6),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.25),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.edit_note,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${pendingTasks.length} tasks pending',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${project.tasks.isEmpty ? 0 : ((completedTasks.length / project.tasks.length) * 100).round()}%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LayoutBuilder(
                                      builder: (context, constraints) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height: 4,
                                          width: constraints.maxWidth,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        if (project.tasks.isNotEmpty)
                                          Container(
                                            height: 4,
                                            width: constraints.maxWidth *
                                                (completedTasks.length /
                                                    project.tasks.length),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.grey[800]
                                                  : Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            );
                          });
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
                    })
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
                  // FocusNode focusNode = FocusNode();
                  // projectBloc.addTask(TaskVM(
                  //   id: DateTime.now().millisecondsSinceEpoch,
                  //   completed: false,
                  //   text: '',
                  //   focusNode: focusNode,
                  // ));
                  // focusNode.requestFocus();
                },
                child: const Text('Add'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            TaskVM task = tasks[index];

            return TaskBox(
              task: task,
              boxWidth: 100,
              toggle: () => null,
              edit: (String text) => null,
              remove: () => null,
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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: ((context, index) {
            TaskVM task = tasks[index];

            return TaskBox(
              task: task,
              boxWidth: 100,
              toggle: () => null,
              edit: (String text) => null,
              remove: () => null,
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
