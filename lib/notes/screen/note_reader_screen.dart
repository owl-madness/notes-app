import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteReaderScreen extends StatefulWidget {
  const NoteReaderScreen({super.key, required this.doc});
  final QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete'),
                    content: Text('Are you sure delete?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance.runTransaction(
                              (Transaction myTransaction) async {
                            myTransaction.delete(widget.doc.reference);
                          }).whenComplete(() => Navigator.pop(context));
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doc["note_title"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.doc["creation_date"],
                style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.doc["note_content"],
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
