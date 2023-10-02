import 'package:rxdart/subjects.dart';
import 'package:what_to_do/mocks/note_mock.dart';
import 'package:what_to_do/models/note_model.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteBloc {
  late final Database noteDB;

  final BehaviorSubject<List<NoteVM>> _notes = BehaviorSubject.seeded([]);
  Stream<List<NoteVM>> get notes => _notes.stream;

  NoteBloc() {
    initDB().then((value) {
      noteDB = value;
      getNotes();
    });

    // getMockNotes();
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        '''
        CREATE TABLE notes(
            id INTEGER PRIMARY KEY, 
            pinned INTEGER, 
            text TEXT, 
            dateTime TEXT
          )
        ''',
      );
    });
  }

  getMockNotes() {
    // noteMockList0.sort((a, b) => -a.dateTime.compareTo(b.dateTime));
    _notes.add(noteMockList0);
  }

  // db
  Future<List<NoteVM>> getNotes({bool updateStream = true}) async {
    final List<Map<String, dynamic>> data = await noteDB.query('notes');

    if (data.isEmpty) {
      return [];
    }

    List<NoteVM> notes = List.generate(data.length, (i) {
      return NoteVM(
        id: data[i]['id'],
        pinned: data[i]['pinned'] == 0 ? false : true,
        text: data[i]['text'],
        dateTime: DateTime.parse(data[i]['dateTime']),
      );
    });

    notes.sort((a, b) => -a.dateTime.compareTo(b.dateTime));

    if (updateStream) {
      _notes.add(notes);
    }
    return notes;
  }

  Future<void> insertNote(NoteVM note) async {
    await noteDB.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    getNotes();
  }

  Future<void> updateNote(NoteVM note) async {
    await noteDB.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );

    getNotes();
  }

  Future<void> deleteNote(NoteVM note) async {
    await noteDB.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [note.id],
    );

    getNotes();
  }
  // db end

  pinNote(NoteVM note) {
    // List<NoteVM> notes = _notes.value;
    // notes.removeWhere((element) => element.id == note.id);
    // notes.insert(0, note.copyWith(pinned: !note.pinned));
    // _notes.add(notes);

    updateNote(note.copyWith(pinned: !note.pinned));
  }

  addNote(NoteVM note) {
    List<NoteVM> notes = _notes.value;
    notes.insert(0, note);
    _notes.add(notes);
  }

  editNote(NoteVM note, String text) async {
    // List<NoteVM> notes = _notes.value;
    // if (text.isEmpty) {
    //   notes.removeWhere((element) => element.id == note.id);
    // } else {
    //   int index = notes.indexWhere((element) => element.id == note.id);
    //   notes[index] = note.copyWith(text: text, dateTime: DateTime.now());
    // }
    // _notes.add(notes);

    List<NoteVM> notes = await getNotes(updateStream: false);
    if (notes.where((element) => element.id == note.id).isEmpty &&
        text.isNotEmpty) {
      insertNote(note.copyWith(text: text));
    } else {
      if (text.isEmpty) {
        deleteNote(note);
      } else {
        updateNote(note.copyWith(text: text, dateTime: DateTime.now()));
      }
    }
  }

  removeNote(NoteVM note) {
    // List<NoteVM> notes = _notes.value;
    // notes.removeWhere((element) => element.id == note.id && !note.pinned);
    // _notes.add(notes);

    deleteNote(note);
  }
}
