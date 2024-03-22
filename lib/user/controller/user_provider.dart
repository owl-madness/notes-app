import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/authentication/screen/signin_screen.dart';
import 'package:notes_app/utilities/appconfigs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>> get userDataStream =>
      FirebaseFirestore.instance
          .collection("note_user_details")
          .where("note_user_id", isEqualTo: AppConfig.userData?.email)
          .snapshots();

  String? nameString;
  String? ageString;

  saveUserDate(BuildContext context) async {
    // var userId = (await SharedPreferences.getInstance())
    //     .getString(AppConfig.userIDPrefKey);

    // var queryData = await FirebaseFirestore.instance
    //       .collection("note_user_details")
    //       .where("note_user_id", isEqualTo: AppConfig.userData?.email).get();
          

    FirebaseFirestore.instance
        .collection("note_user_details")
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (element["note_user_id"] == AppConfig.userData?.email) {
          if (nameString?.toLowerCase().trim() != element["note_user_name"] ||
              ageString?.toLowerCase().trim() != element["note_user_age"]) {
            FirebaseFirestore.instance
                .collection("note_user_details")
                .doc(element.reference.id)
                .set({
              "note_user_name": nameString ?? element["note_user_name"],
              "note_user_age": int.tryParse(ageString!) ?? element["note_user_age"],
              "note_user_id": AppConfig.userData?.email
            }).whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Done')));
            });
          }
        }
      }
    });

    // FirebaseFirestore.instance.collection("note_user_details").add({
    //   "note_user_name": nameString?.trim(),
    //   "note_user_age": ageString?.trim(),
    //   "note_user_id": userId
    // });
  }

  onLogoutPressed(BuildContext context) async {
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
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final pref = await SharedPreferences.getInstance();
                          pref.setBool(AppConfig.loggedStateKey, false);
                          pref.setString(AppConfig.userIDPrefKey, '');
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen(),), (route) => false);
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
                    ],
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
}
