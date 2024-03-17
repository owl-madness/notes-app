import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes_app/authentication/screen/signin_screen.dart';
import 'package:notes_app/notes/screen/note_edit_screen.dart';
import 'package:notes_app/notes/screen/note_reader_screen.dart';
import 'package:notes_app/utilities/appconfigs.dart';
import 'package:notes_app/utilities/widget/note_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notes',
          style: TextStyle(),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BottomSheet(
                      onClosing: () {},
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Logout',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Are you sure logout?'),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    final pref = await SharedPreferences.getInstance();
                                    pref.setBool(AppConfig.loggedStateKey, false);
                                    pref.setString(AppConfig.userIDPrefKey, '');
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red)),
                                  child: Text('Logout',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              icon: Icon(Icons.person))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteEditorScreen(),
              )),
          label: Text('Add note')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'Recent Notes',
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("notes")
                  .where('user_id', isEqualTo: AppConfig.userID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      children: snapshot.data!.docs
                          .map((note) => noteCard(
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NoteReaderScreen(doc: note),
                                  )),
                              note))
                          .toList());
                }
                return Center(
                  child: Text('There\'s no notes'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
