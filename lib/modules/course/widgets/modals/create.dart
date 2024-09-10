import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';

Future<bool> showCourseCreationModal(BuildContext context) =>
    showModalBottomSheet<bool>(
      context: context,
      builder: (context) => const CreateCourseModal(),
    ).then((created) => created ?? false);

class CreateCourseModal extends StatefulWidget {
  const CreateCourseModal({super.key});

  @override
  State<CreateCourseModal> createState() => _CreateCourseModalState();
}

class _CreateCourseModalState extends State<CreateCourseModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(S.of(context).createANewCourse),
              centerTitle: true,
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: S.of(context).name),
              validator: (name) => (name == null || name.length < 3)
                  ? "Provide a name for the course"
                  : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: S.of(context).description),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submitCourseCreation,
              child: Text(S.of(context).createCourse),
            ),
          ],
        ),
      );

  void _submitCourseCreation() async {
    // Check valid input
    if (_formKey.currentState?.validate() != true) return;

    try {
      await supabase.from("courses").insert({
        "name": _nameController.text,
        "description": _descriptionController.text,
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text("An error occurred: $e"),
          ),
        );
      }
    }
  }
}
