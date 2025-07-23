import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_papers/models/aes_cipher.dart';
import 'package:my_papers/models/note.dart';
import 'package:my_papers/models/utils.dart';
import 'package:my_papers/objectbox.g.dart'; // created by `flutter pub run build_runner build`

class NoteDatabase extends ChangeNotifier {
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
    final nt = _noteBox.query(Note_.date.equals(date.millisecondsSinceEpoch)).build().findFirst();
    if(nt != null) {
      return false;
    }
    final note = Note(text: text, date: date, iv: "");
    _noteBox.put(note);
    fetchNote(fdate: date);
    return true;
  }

  void fetchNote({DateTime? fdate, bool? notnotify}) {
    fdate ??= DateTime.now();
    final (start, end) = getWeekRange(fdate);
    startDate = start;
    endDate = end;
    final query = _noteBox.query(Note_.date.between(start.millisecondsSinceEpoch, end.millisecondsSinceEpoch));
    currentNotes.clear();
    currentNotes.addAll(query.build().find());
    if(notnotify == null || !notnotify) {
      notifyListeners();
    }
  }

  void updateNote(int id, String text) {
    final existingNote = _noteBox.get(id);
    if(existingNote != null) {
      final cipherinfo = GetIt.I<AESCipher>().encryptText(text: text);
      existingNote.text = cipherinfo.ciphertext;
      existingNote.iv = cipherinfo.iv;
      _noteBox.put(existingNote);
    }
    //fetchNote(fdate: startDate);

  }

  void deleteNote(int id) {
    _noteBox.remove(id);
    fetchNote(fdate: startDate);
  }

}