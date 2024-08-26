import 'package:all_in_order/db/models/profile.dart';
import 'package:all_in_order/db/models/project_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showTaskViewModal(BuildContext context, ProjectTask task) {
  showModalBottomSheet(
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _dueDate;

  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text(widget.task.title),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.of(context).pop(),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(widget.task.description ?? "No description"),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
                    future: Profile.fetchById(widget.task.createdBy!),
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
                    }
                ),
            ],
          ),
        ],
      ),
    );
  }
}