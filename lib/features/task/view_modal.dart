import 'dart:async';

import 'package:all_in_order/db/models/profile.dart';
import 'package:all_in_order/db/models/project_task.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future showTaskViewModal(BuildContext context, ProjectTask task) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => TaskViewModal(task: task),
  );
}

class TaskViewModal extends StatefulWidget {
  const TaskViewModal({super.key, required this.task});

  final ProjectTask task;

  @override
  State<TaskViewModal> createState() => _TaskViewModalState();
}

class _TaskViewModalState extends State<TaskViewModal> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.task.title);
  late final TextEditingController _descriptionController =
      TextEditingController(text: widget.task.description);

  late DateTime? _dueDate = widget.task.dueDate;

  bool _editMode = false;

  late final Future<Profile?> _createdByRequest =
      Profile.fetchById(widget.task.createdBy!);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: _editMode
                ? TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                  )
                : Text(widget.task.title),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            actions: _editMode
                ? [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _saveChanges,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () => setState(() => _editMode = false),
                    ),
                  ]
                : [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => setState(() => _editMode = !_editMode),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
          ),
          const SizedBox(height: 8),
          if (_editMode)
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
            )
          else
            Center(child: Text(widget.task.description ?? "No description")),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (_editMode)
                ActionChip(
                  label: Text(_dueDate != null
                      ? DateFormat.yMMMd().format(_dueDate!)
                      : 'Set due date'),
                  avatar: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (context.mounted) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
                      );

                      if (selectedDate != null && selectedTime != null) {
                        setState(() {
                          _dueDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                      }
                    }
                  },
                )
              else
                Column(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(height: 8),
                    Text(widget.task.dueDate != null
                        ? DateFormat.yMMMd().format(widget.task.dueDate!)
                        : "No due date"),
                  ],
                ),
              if (widget.task.createdBy != null)
                FutureBuilder(
                    future: _createdByRequest,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return const Text('An error occurred');
                      }

                      final createdBy = snapshot.data as Profile;

                      return Column(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(height: 8),
                          Text(createdBy.name),
                        ],
                      );
                    }),
            ],
          ),
        ],
      ),
    );
  }

  Future _saveChanges() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    try {
      await supabase.from('project_tasks').update({
        'title': title,
        'description': description,
        'pending_date': _dueDate.toString(),
      }).eq('id', widget.task.id);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred'),
          ),
        );
      }
    }
  }
}
