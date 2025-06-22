import 'package:my_papers/models/note.dart';
import 'package:my_papers/objectbox.g.dart'; // created by `flutter pub run build_runner build`

class NoteDatabase {
  late final Store _store;
  late final Box<Note> _noteBox;

  ///fetched Notes [fetchNote]
  final List<Note> currentNotes = [];

  late DateTime startDate;
  late DateTime endDate;
  

  NoteDatabase._create(this._store)  {
    _noteBox = _store.box<Note>();
  }

  static Future<NoteDatabase> create() async {
    final store = await openStore();
    return NoteDatabase._create(store);
    
  }

  ///Add [Note] to db with encryption using [AESCipher]
  bool addNote(String text, DateTime date) {
    final note = Note(text: text, date: date, iv: "");
    _noteBox.put(note);
    return true;
  }
}