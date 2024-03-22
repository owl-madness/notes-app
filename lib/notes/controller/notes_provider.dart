import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/user/screen/profile_screen.dart';
import 'package:notes_app/utilities/appconfigs.dart';

class NotesProvider extends ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>> get noteStream =>
      FirebaseFirestore.instance
          .collection("notes")
          .where('user_id', isEqualTo: AppConfig.userData?.email)
          .snapshots();

  onProfileTap(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ));
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
      "user_id": AppConfig.userData,
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
