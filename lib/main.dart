import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/authentication/controller/auth_provider.dart';
import 'package:notes_app/notes/controller/notes_provider.dart';
import 'package:notes_app/authentication/screen/splash_screen.dart';
import 'package:notes_app/user/controller/user_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}




///this is s sample code that with birthday in dartpad.dev

// void main() {
//   Future<void> waitFunc(int second, String msg) async {
//     await Future.delayed(Duration(seconds: second));
//     print(msg);
//     return;
//   }

//   void wishBday() async {
//     await waitFunc(2, "Today is Month D.");
//     await waitFunc(3, "Do you know what's special??!!🤔");
//     await waitFunc(2, "Yes, its NAME's B'DAY 🥳🎉");
//     await waitFunc(1, "Wish him now");
//     await waitFunc(2, "HAPPY B'DAY BRUH ❤️");
//   }

//   wishBday();
// }

