import 'package:flutter/material.dart';
import 'package:notes_app/notes/controller/notes_provider.dart';
import 'package:notes_app/notes/screen/note_edit_screen.dart';
import 'package:notes_app/notes/screen/note_reader_screen.dart';
import 'package:notes_app/utilities/widget/note_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Notes',
            style: TextStyle(),
          ),
          actions: [
            IconButton(
              onPressed: () => notesProvider.onProfileTap(context),
              icon: const Icon(Icons.person),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              notesProvider.navigateScreen(context, const NoteEditorScreen()),
          label: const Text('Add note'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Recent Notes',
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: StreamBuilder(
                stream: notesProvider.noteStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        children: snapshot.data!.docs
                            .map((note) => noteCard(
                                () => notesProvider.navigateScreen(
                                    context, NoteReaderScreen(doc: note)),
                                note))
                            .toList());
                  }
                  return const Center(
                    child: Text('There\'s no notes'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
