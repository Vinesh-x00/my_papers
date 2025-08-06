import 'package:flutter/material.dart';
import 'package:my_papers/models/note.dart';
import 'package:my_papers/models/utils.dart';
import 'package:my_papers/pages/note_editor.dart';

/// Single [Note] representation in homepage
class NoteTile extends StatelessWidget {
  final void Function(int) delete;
  final Note note;

  const NoteTile({super.key, required this.delete, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 20),

      ///Tile syling
      child: ListTile(
        title: Text(formatDate(date: note.date)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Button to modify note with [NoteEditor]
            IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditor(note: note),
                      ),
                    ),
                icon: Icon(Icons.edit)),

            /// Button to delete Note
            IconButton(
              /// Confirmation dialogue to delete note
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content: const Text("Deleting note"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                delete(note.id);
                                Navigator.pop(context);
                              },
                              child: const Text("Ok"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                          ],
                        )),
                icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
