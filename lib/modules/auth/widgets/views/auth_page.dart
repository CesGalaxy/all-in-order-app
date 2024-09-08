import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).authentication),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.email),
              labelText: S.of(context).email,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.lock),
              labelText: S.of(context).password,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            children: [
              FilledButton(
                onPressed: _login,
                child: Text(S.of(context).logIn),
              ),
              FilledButton(
                onPressed: _register,
                child: Text(S.of(context).register),
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
