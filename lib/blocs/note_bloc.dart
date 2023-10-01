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
}
