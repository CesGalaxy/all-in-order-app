import 'package:all_in_order/db/models/profile.dart';
import 'package:all_in_order/db/models/project.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key, required this.project});

  final Project project;

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
                                  _dueDate = DateTime(
                                    value!.year,
                                    value.month,
                                    value.day,
                                    time.hour,
                                    time.minute,
                                  );
                                  setState(() {});
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

    supabase.from('project_tasks').upsert({
      'project_id': widget.project.id,
      'title': title,
      'description': description,
      'pending_date': _dueDate.toString(),
      'created_by': _showCreatedByMe
          ? Provider.of<Profile>(context, listen: false).id
          : null,
    }).then((response) {
      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error!.message),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    });
  }
}
