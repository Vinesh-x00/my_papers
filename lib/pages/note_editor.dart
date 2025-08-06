import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get_it/get_it.dart';
import 'package:my_papers/models/aes_cipher.dart';
import 'package:my_papers/models/note_database.dart';
import 'package:my_papers/models/note.dart';
import 'package:provider/provider.dart';

class NoteEditor extends StatefulWidget {
  final Note note;
  const NoteEditor({super.key, required this.note});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

/// [Note] editor
class _NoteEditorState extends State<NoteEditor> {
  final QuillController _controller = QuillController.basic();

  @override
  void initState() {
    if(widget.note.text.isNotEmpty) {
      final cinfo = EncryptedInfo(widget.note.iv, widget.note.text);
      final decryptedTxt = GetIt.I<AESCipher>().decrypt(cinfo);
      //final decryptedTxt = widget.note.text;
      _controller.document = Document()..insert(0, decryptedTxt);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) {
              return;
            }
            final text = _controller.document.toPlainText().trim();
            context.read<NoteDatabase>().updateNote(widget.note.id, text);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
                  child: QuillEditor.basic(controller: _controller),
                ),
              ),
            ],
          ),
        ));
  }
}
