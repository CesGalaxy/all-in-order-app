import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';

class CreateProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  CreateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.person),
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.alternate_email),
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _createProfile,
                child: const Text("Create Profile"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _createProfile() {
    final name = nameController.text;
    final username = usernameController.text;

    supabase.auth.signOut();

    // Create profile
  }
}