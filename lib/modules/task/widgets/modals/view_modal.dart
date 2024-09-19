import 'dart:async';

import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<bool?> showTaskViewModal(
  BuildContext context,
  SubjectEvent event, [
  bool initialEditMode = false,
]) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => TaskViewModal(task: event, editMode: initialEditMode),
  );
}

class TaskViewModal extends StatefulWidget {
  const TaskViewModal({super.key, required this.task, this.editMode = false});

  final SubjectEvent task;
  final bool editMode;

  @override
  State<TaskViewModal> createState() => _TaskViewModalState();
}

class _TaskViewModalState extends State<TaskViewModal> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.task.title);
  late final TextEditingController _detailsController =
      TextEditingController(text: widget.task.details);

  late DateTime? _dueDate = widget.task.endsAt;

  late bool _editMode = widget.editMode;

  // late final Future<Profile?> _createdByRequest =
  //     Profile.fetchById(widget.task.a!);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5 +
          MediaQuery.of(context).viewInsets.bottom,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: false,
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ListView(
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
                          onPressed: () =>
                              setState(() => _editMode = !_editMode),
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
                  controller: _detailsController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                )
              else
                Center(child: Text(widget.task.details ?? "No details")),
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
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );

                        if (context.mounted) {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                _dueDate ?? DateTime.now()),
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
                        Text(widget.task.endsAt != null
                            ? DateFormat.yMMMd().format(widget.task.endsAt!)
                            : "No due date"),
                      ],
                    ),
                  const Column(
                    children: [
                      Icon(Icons.person),
                      SizedBox(height: 8),
                      Text("No author"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _saveChanges() async {
    final title = _titleController.text;
    final description = _detailsController.text;

    try {
      await supabase.from('subject_events').update({
        'title': title,
        'details': description,
        'ends_at': _dueDate?.toIso8601String(),
      }).eq('id', widget.task.id);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }
}
