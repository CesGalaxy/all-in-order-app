import 'package:all_in_order/generated/l10n.dart';
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
        title: Text(S.of(context).createProfile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.person),
              labelText: S.of(context).name,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.alternate_email),
              labelText: S.of(context).username,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _createProfile,
                child: Text(S.of(context).createProfile),
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
