import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/models/note_model.dart';
import 'package:what_to_do/widgets/note_box.dart';

class NotePage extends StatelessWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    NoteBloc noteBloc = context.read<NoteBloc>();

    return StreamBuilder<List<NoteVM>>(
        stream: noteBloc.notes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<NoteVM> notes = snapshot.data!;

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

          List<NoteVM> pinnedNotes =
              notes.where((element) => element.pinned).toList();
          List<NoteVM> justNotes =
              notes.where((element) => !element.pinned).toList();

          notes = pinnedNotes + justNotes;

          return ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            itemBuilder: (context, index) {
              NoteVM note = notes[index];

              return NoteBox(
                note: note,
                boxWidth: 100,
                pin: () => noteBloc.pinNote(note),
                submit: (String text) => noteBloc.editNote(note, text),
                remove: () => noteBloc.removeNote(note),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },
            itemCount: notes.length,
          );
        });
  }
}
