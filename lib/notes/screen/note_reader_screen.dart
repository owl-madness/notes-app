import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/notes/controller/notes_provider.dart';
import 'package:provider/provider.dart';

class NoteReaderScreen extends StatelessWidget {
  const NoteReaderScreen({super.key, required this.doc});
  final QueryDocumentSnapshot doc;

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, noteProvider, child) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete'),
                    content: const Text('Are you sure delete?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () => noteProvider.deleteNote(context, doc.reference),
                        child: const Text('Delete'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc["note_title"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  doc["creation_date"],
                  style: const TextStyle(
                      fontSize: 10, fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  doc["note_content"],
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
