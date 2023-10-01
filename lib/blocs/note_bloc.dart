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
    _notes.add(noteMockList0);
  }
}
