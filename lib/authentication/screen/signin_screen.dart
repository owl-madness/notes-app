import 'package:flutter/material.dart';
import 'package:notes_app/authentication/controller/auth_provider.dart';
import 'package:notes_app/authentication/screen/signup_screen.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
        child: Consumer<AuthProvider>(
          builder: (context, value, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign in',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: value.usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefix: Icon(Icons.email),
                    label: Text('Email')),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: value.passwordController,
                obscureText: value.isHidden,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefix: Icon(Icons.lock),
                    suffix: GestureDetector(
                        onTap: () => value.changeVisibility(),
                        child: Icon(value.isHidden
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    label: Text('Password')),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () => value.loginUser(
                      value.usernameController.text.trim(),
                      value.passwordController.text.trim(),
                      context),
                  child: Text('Login')),
              SizedBox(height: 20),
              TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                      )),
                  child: Text('Create account'))
            ],
          ),
        ),
      ),
    );
  }
}
