import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/features/auth/auth_service.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key, required this.subject});

  final Subject subject;

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
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
                            ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(_dueDate!)
                            : ""),
                    readOnly: true,
                    onTap: () => showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        ).then((value) => setState(() {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              ).then((time) {
                                if (time != null) {
                                  setState(() {
                                    _dueDate = DateTime(
                                      value!.year,
                                      value.month,
                                      value.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                }
                              });
                            }))),
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
            const Center(child: Text('Create Task Page!')),
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
    final description = _descriptionController.text;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    try {
      // supabase.from('subject_tasks').insert({
      //   'subject_id': widget.subject.id,
      //   'title': title,
      //   'description': description,
      //   'starts_at': _dueDate.toString(),
      //   // 'created_by': _showCreatedByMe
      //   //     ? Provider.of<AuthService>(context, listen: false).profile!.id
      //   //     : null,
      // }).then((_) {
        Navigator.pop(context);
      //});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }
}
