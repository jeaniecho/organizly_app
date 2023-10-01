import 'package:rxdart/subjects.dart';
import 'package:what_to_do/mocks/note_mock.dart';
import 'package:what_to_do/models/note_model.dart';

class NoteBloc {
  final BehaviorSubject<List<NoteVM>> _notes = BehaviorSubject.seeded([]);
  Stream<List<NoteVM>> get notes => _notes.stream;

  NoteBloc() {
    getMockNotes();
  }

  getMockNotes() {
    // noteMockList0.sort((a, b) => -a.dateTime.compareTo(b.dateTime));
    _notes.add(noteMockList0);
  }

  pinNote(NoteVM note) {
    List<NoteVM> notes = _notes.value;
    notes.removeWhere((element) => element.id == note.id);
    notes.insert(0, note.copyWith(pinned: !note.pinned));
    _notes.add(notes);
  }

  addNote(NoteVM note) {
    List<NoteVM> notes = _notes.value;
    notes.insert(0, note);
    _notes.add(notes);
  }

  editNote(NoteVM note, String text) {
    List<NoteVM> notes = _notes.value;
    if (text.isEmpty) {
      notes.removeWhere((element) => element.id == note.id);
    } else {
      int index = notes.indexWhere((element) => element.id == note.id);
      notes[index] = note.copyWith(text: text, dateTime: DateTime.now());
    }

    _notes.add(notes);
  }

  removeNote(NoteVM note) {
    List<NoteVM> notes = _notes.value;
    notes.removeWhere((element) => element.id == note.id && !note.pinned);
    _notes.add(notes);
  }
}
