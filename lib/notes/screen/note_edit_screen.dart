import 'package:flutter/material.dart';
import 'package:notes_app/notes/controller/notes_provider.dart';
import 'package:provider/provider.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  String dateTime = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Add new note'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => notesProvider.addNewNote(
              context,
              titleController.text.trim(),
              noteController.text.trim(),
              dateTime),
          child: const Icon(Icons.save),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(dateTime),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: noteController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type note here...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
