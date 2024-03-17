import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/utilities/appconfigs.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new note'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FirebaseFirestore.instance.collection("notes").add({
            "creation_date": dateTime,
            "user_id": AppConfig.userID,
            "note_title": titleController.text.trim(),
            "note_content": noteController.text.trim()
          }).then((value) {
            print(value.id);
            Navigator.pop(context);
          }).catchError((error) => print(error));
        },
        child: Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(dateTime),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: noteController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                
                  border: InputBorder.none, hintText: 'Type note here...',),
            ),
          ],
        ),
      ),
    );
  }
}
