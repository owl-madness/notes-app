import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/authentication/authentication_helper.dart';
import 'package:notes_app/authentication/screen/signin_screen.dart';
import 'package:notes_app/notes/screen/home_screen.dart';
import 'package:notes_app/user/model/user_model.dart';
import 'package:notes_app/utilities/appconfigs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final cfpasswordController = TextEditingController();
  bool isHidden = true;
  bool isSUHidden = true;
  bool isCfHidden = true;

  void changeVisibility() {
    isHidden = !isHidden;
    notifyListeners();
  }

  void changeSUHVisibility() {
    isSUHidden = !isSUHidden;
    notifyListeners();
  }

  void changeCFVisibility() {
    isCfHidden = !isCfHidden;
    notifyListeners();
  }

  String? emailValidation(String? email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (email?.isEmpty ?? true) {
      return 'Enter email';
    } else {
      if (!(email!.contains(regex))) {
        return "Invalid Email";
      }
      return null;
    }
  }

  String? passwordValidation(String? password) {
    if (password?.isEmpty ?? true) {
      return 'Enter password';
    } else if (password!.length < 6) {
      return 'Minimum length is 6';
    }
    return null;
  }

  void loginUser(String email, String password, BuildContext context) {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        AuthenticationHelper()
            .signIn(email: email, password: password)
            .then((result) async {
          if (result == null) {
            final pref = await SharedPreferences.getInstance();
            pref.setString(AppConfig.userIDPrefKey, email);
            pref.setBool(AppConfig.loggedStateKey, true);

            int? age;
            String? name;
            var user = await FirebaseFirestore.instance
                .collection("note_user_details")
                .get();
            for (var value in user.docs) {
              if (value["note_user_id"].toLowerCase().trim() ==
                  email.toLowerCase().trim()) {
                age = int.tryParse(value["note_user_age"]);
                name = value["note_user_name"];
              }
            }
            AppConfig.userData = UserData(name: name, age: age, email: email);

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(result.toString())));
          }
        });
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter Credentials')));
    }
  }

  void signupUser(String email, String password, BuildContext context) {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        AuthenticationHelper()
            .signUp(email: email, password: password)
            .then((result) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text((result ?? 'Success').toString())));
          if (result == null) {
            usernameController.clear();
            passwordController.clear();
            cfpasswordController.clear();
            Navigator.pop(context);
          } else {
            debugPrint('sign result $result');
          }
        });
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter Credentials')));
    }
  }

  void checkLoggedState(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    bool? loggedstate = pref.getBool(AppConfig.loggedStateKey);
    if (loggedstate ?? false) {
      var email = pref.getString(AppConfig.userIDPrefKey);
      int? age;
      String? name;
      var user = await FirebaseFirestore.instance
          .collection("note_user_details")
          .get();
      for (var value in user.docs) {
        if (value["note_user_id"].toLowerCase().trim() ==
            email?.toLowerCase().trim()) {
          age = int.tryParse(value["note_user_age"]);
          name = value["note_user_name"];
        }
      }
      AppConfig.userData = UserData(name: name, age: age, email: email);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false);
    }
  }
}
