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
              const Text(
                'Sign in',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: value.usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefix: Icon(Icons.email),
                    label: Text('Email')),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: value.passwordController,
                obscureText: value.isHidden,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    prefix: const Icon(Icons.lock),
                    suffix: GestureDetector(
                        onTap: () => value.changeVisibility(),
                        child: Icon(value.isHidden
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    label: const Text('Password')),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () => value.loginUser(
                      value.usernameController.text.trim(),
                      value.passwordController.text.trim(),
                      context),
                  child: const Text('Login')),
              const SizedBox(height: 20),
              TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      )),
                  child: const Text('Create account'))
            ],
          ),
        ),
      ),
    );
  }
}
