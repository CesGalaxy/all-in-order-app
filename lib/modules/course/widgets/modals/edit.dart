import 'package:all_in_order/db/models/course.dart';
import 'package:flutter/material.dart';

Future<bool> showCourseEditModal(BuildContext context, Course course) =>
    showModalBottomSheet<bool>(
      context: context,
      builder: (context) => EditCourseModal(course: course),
    ).then((created) => created ?? false);

class EditCourseModal extends StatefulWidget {
  const EditCourseModal({super.key, required this.course});

  final Course course;

  @override
  State<EditCourseModal> createState() => _EditCourseModalState();
}

class _EditCourseModalState extends State<EditCourseModal> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.course.name);
    _descriptionController =
        TextEditingController(text: widget.course.description);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppBar(
            title: const Text("Edit course"),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _submitCourseUpdate,
              ),
            ],
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description"),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submitCourseUpdate,
            child: const Text("Update course"),
          ),
        ],
      );

  void _submitCourseUpdate() async {}
}
