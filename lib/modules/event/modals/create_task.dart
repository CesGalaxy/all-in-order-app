import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<bool> pushCreateTaskPage(BuildContext context, int subjectId) async {
  final data =
      await Navigator.of(context).push<(String, String?, DateTime?, bool)>(
    MaterialPageRoute(
      builder: (context) => const CreateTaskEventModal(),
    ),
  );

  if (data == null) return false;

  final (title, details, dueDate, _) = data;

  try {
    await supabase.from("subject_events").insert({
      "subject_id": subjectId,
      "title": title,
      "details": details,
      "type": "TASK",
      "starts_at": DateTime.now().toIso8601String(),
      "ends_at": dueDate?.toIso8601String(),
    });

    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create task: $e'),
        ),
      );
    }
  }

  return false;
}

class CreateTaskEventModal extends StatefulWidget {
  const CreateTaskEventModal({super.key});

  @override
  State<CreateTaskEventModal> createState() => _CreateTaskEventModalState();
}

class _CreateTaskEventModalState extends State<CreateTaskEventModal> {
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();

  DateTime? _dueDate;

  bool _showCreatedByMe = true;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Task'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.article), text: 'Details'),
              Tab(icon: Icon(Icons.people), text: 'Collaborators'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Due Date (optional)',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                      text: _dueDate != null
                          ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                          : ""),
                  readOnly: true,
                  onTap: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  ).then(
                    (value) => setState(() {
                      if (value != null) _dueDate = value;
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Created by me'),
                  value: _showCreatedByMe,
                  onChanged: (bool? value) => setState(() {
                    _showCreatedByMe = value!;
                  }),
                ),
              ],
            ),
            const Center(child: Text('Coming Soon!')),
          ],
        ),
        bottomSheet: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _createTask,
            child: const Text('Create Task'),
          ),
        ),
      ),
    );
  }

  void _createTask() {
    final title = _titleController.text;
    final description = _descriptionController.text.isEmpty
        ? null
        : _descriptionController.text;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    try {
      Navigator.pop(context, (title, description, _dueDate, _showCreatedByMe));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }
}
