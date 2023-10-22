import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/models/note_model.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/widgets/note_box.dart';
import 'package:what_to_do/widgets/project_box.dart';
import 'package:what_to_do/widgets/task_box.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeNotes(),
          HomeProjects(),
          HomeTasks(),
        ],
      ),
    );
  }
}

class HomeNotes extends StatelessWidget {
  const HomeNotes({super.key});

  @override
  Widget build(BuildContext context) {
    NoteBloc noteBloc = context.read<NoteBloc>();
    AppBloc appBloc = context.read<AppBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          StreamBuilder(
              stream: noteBloc.notes,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<NoteVM> notes =
                    snapshot.data!.where((element) => element.pinned).toList();

                if (notes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No notes',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                double noteSize = 100;

                return SizedBox(
                  height: noteSize + 24,
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        NoteVM note = notes[index];

                        return GestureDetector(
                            onTap: () {
                              appBloc.setBottomIndex(3);
                            },
                            child: HomeNoteBox(note: note, boxWidth: noteSize));
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 12);
                      },
                      itemCount: notes.length),
                );
              }),
        ],
      ),
    );
  }
}

class HomeProjects extends StatelessWidget {
  const HomeProjects({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectBloc projectBloc = context.read<ProjectBloc>();
    AppBloc appBloc = context.read<AppBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Projects',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        StreamBuilder<List<ProjectVM>>(
            stream: projectBloc.projects,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<ProjectVM> projects = snapshot.data!;

              if (projects.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                      child: Text(
                    'No projects',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )),
                );
              }

              return SizedBox(
                height: 124,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemBuilder: (context, index) {
                    ProjectVM project = projects[index];

                    List<TaskVM> pendingTasks = project.tasks
                        .where((element) => !element.completed)
                        .toList();
                    List<TaskVM> completedTasks = project.tasks
                        .where((element) => element.completed)
                        .toList();

                    return GestureDetector(
                      onTap: () {
                        appBloc.setBottomIndex(2);
                        projectBloc.setPageIndex(index);
                        projectBloc.pageController.jumpToPage(index);
                      },
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        child: ProjectBox(
                          project: project,
                          isSelected: false,
                          pendingTasks: pendingTasks.length,
                          completedTasks: completedTasks.length,
                          edit: (title) =>
                              projectBloc.editProject(project, title),
                          remove: () => projectBloc.removeProject(project),
                        ),
                      ),
                    );
                  },
                  itemCount: projects.length,
                ),
              );
            }),
        const SizedBox(height: 12),
      ],
    );
  }
}

class HomeTasks extends StatelessWidget {
  const HomeTasks({super.key});

  @override
  Widget build(BuildContext context) {
    TaskBloc taskBloc = context.read<TaskBloc>();
    AppBloc appBloc = context.read<AppBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Todo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          StreamBuilder(
              stream: taskBloc.tasks,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<TaskVM> tasks = snapshot.data!;

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

                // List<TaskVM> pendingTasks =
                //     tasks.where((element) => !element.completed).toList();
                // List<TaskVM> completedTasks =
                //     tasks.where((element) => element.completed).toList();

                // tasks = pendingTasks + completedTasks;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    TaskVM task = tasks[index];

                    return HomeTaskBox(
                      task: task,
                      boxWidth: 100,
                      toggle: () => taskBloc.toggleTask(task),
                    );
                  }),
                  separatorBuilder: ((context, index) {
                    return const SizedBox(height: 12);
                  }),
                  itemCount: tasks.length,
                );
              }),
        ],
      ),
    );
  }
}
