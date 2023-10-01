import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/models/note_model.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/widgets/note_box.dart';
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
          SizedBox(height: 12),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
                    padding: EdgeInsets.symmetric(vertical: 12),
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

                        return SmallNoteBox(note: note, boxWidth: noteSize);
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Projects',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeTasks extends StatelessWidget {
  const HomeTasks({super.key});

  @override
  Widget build(BuildContext context) {
    TaskBloc taskBloc = context.read<TaskBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tasks',
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
