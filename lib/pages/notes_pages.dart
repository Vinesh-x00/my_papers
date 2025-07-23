import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_papers/models/note_database.dart';
import 'package:my_papers/components/calander_filter.dart';
import 'package:my_papers/components/drawer.dart';
import 'package:my_papers/components/note_tile.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    readNotes();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  /// Date choosing box to add new note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Date"),
        content: TextField(
          controller: textController,
          onTap: () => selectDate(),
          decoration: const InputDecoration(
              labelText: 'DATE',
              filled: true,
              prefixIcon: Icon(Icons.calendar_today_rounded)),
          readOnly: true,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              final res =
                  context.read<NoteDatabase>().addNote("", selectedDate);
              textController.clear();

              if (context.mounted) {
                if (!res) {
                  final snackbar = SnackBar(
                    content: Text("Cannot create multiple notes for same date"),
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 2),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
                Navigator.pop(context);
              }
            },

            child: Text("Create"),
          )
        ],
      ),
    );
  }

  void readNotes() {
    context.read<NoteDatabase>().fetchNote(notnotify: true);
  }

  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  /// Date picker
  Future<void> selectDate() async {
    final currentDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(currentDate.year - 1),
      lastDate: DateTime(currentDate.year + 1, 12, 31),
    );
    picked ??= currentDate;
    textController.text = picked.toString().split(" ")[0];
    selectedDate = picked;
  }

  @override
  Widget build(BuildContext context) {
    final notedb = context.watch<NoteDatabase>();
    final currentNotes = notedb.currentNotes;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          elevation: 10,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNote,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          shape: StarBorder.polygon(pointRounding: 1),
          child: const Icon(Icons.add),
        ),
        drawer: const MyDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "MY PAPERS",
                style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CalanderFilter(
                  startDate: notedb.startDate, endDate: notedb.endDate),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  return NoteTile(
                      delete: deleteNote, note: currentNotes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
