import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/authentication/screen/signin_screen.dart';
import 'package:notes_app/utilities/appconfigs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesProvider extends ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>> get noteStream =>
      FirebaseFirestore.instance
          .collection("notes")
          .where('user_id', isEqualTo: AppConfig.userID)
          .snapshots();

  onProfileTap(BuildContext context) async {
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
                  const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text('Are you sure logout?'),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pref = await SharedPreferences.getInstance();
                      pref.setBool(AppConfig.loggedStateKey, false);
                      pref.setString(AppConfig.userIDPrefKey, '');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  navigateScreen(BuildContext context, Widget newPage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newPage,
      ),
    );
  }

  deleteNote(BuildContext context, DocumentReference<Object?> reference) async {
    Navigator.pop(context);
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(reference);
    }).whenComplete(() => Navigator.pop(context));
  }

  addNewNote(BuildContext context, String noteTitle, String noteContent,
      String dateTime) async {
    FirebaseFirestore.instance.collection("notes").add({
      "creation_date": dateTime,
      "user_id": AppConfig.userID,
      "note_title": noteTitle,
      "note_content": noteContent
    }).then((value) {
      debugPrint(value.id);
      Navigator.pop(context);
    }).catchError((error) {
      debugPrint(error);
    });
  }
}
