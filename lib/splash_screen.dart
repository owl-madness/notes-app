import 'package:flutter/material.dart';
import 'package:notes_app/authentication/screen/signin_screen.dart';
import 'package:notes_app/notes/screen/home_screen.dart';
import 'package:notes_app/utilities/appconfigs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLoggedState();
    super.initState();
  }

  void checkLoggedState() async {
    final pref = await  SharedPreferences.getInstance();
    bool? loggedstate = pref.getBool(AppConfig.loggedStateKey);
    if(loggedstate ?? false){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen(),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}