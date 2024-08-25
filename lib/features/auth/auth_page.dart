import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.email),
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.lock),
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            children: [
              FilledButton(
                onPressed: _login,
                child: const Text("Log In"),
              ),
              FilledButton(
                onPressed: _register,
                child: const Text("Register"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _register() {
    final email = emailController.text;
    final password = passwordController.text;

    // Register user
    supabase.auth.signUp(email: email, password: password);
  }

  void _login() {
    final email = emailController.text;
    final password = passwordController.text;

    // Login user
    supabase.auth.signInWithPassword(email: email, password: password);
  }
}
