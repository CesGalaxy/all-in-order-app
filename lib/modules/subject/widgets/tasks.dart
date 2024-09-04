import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/widgets/empty_collection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api/cached_collection.dart';
import '../../../db/models/subject_task.dart';
import '../../task/create_page.dart';
import '../../task/view_modal.dart';

class SubjectTasksPage extends StatefulWidget {
  const SubjectTasksPage({super.key, required this.subject});

  final Subject subject;

  @override
  State<SubjectTasksPage> createState() => _SubjectTasksPageState();
}

class _SubjectTasksPageState extends State<SubjectTasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<CachedCollection<SubjectEvent>>(context).fetch(),
        builder: (context, snapshot) => Consumer<CachedCollection<SubjectEvent>>(
          builder: (context, tasksCache, child) {
            switch (tasksCache.status) {
              case CachedDataStatus.initializing:
                return const Center(child: CircularProgressIndicator());
              case CachedDataStatus.error:
                return Center(child: Text('Error: ${tasksCache.error}'));
              case CachedDataStatus.done:
                final tasks = tasksCache.items.where((task) => task.type == 'TASK').toList();

                if (tasks.isEmpty) {
                  // Show a Card with action
                  return EmptyCollectionScreen(
                    title: 'No tasks found',
                    actionLabel: 'Create Task',
                    action: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateTaskPage(subject: widget.subject),
                    )),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => tasksCache.fetch(force: true),
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.details ?? "No description"),
                        onTap: () async {
                          await showTaskViewModal(context, task);
                          if (context.mounted) {
                            Provider.of<CachedCollection<SubjectTask>>(context,
                                    listen: false)
                                .fetch(force: true);
                          }
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            // Navigate to edit task
                          },
                        ),
                      );
                    },
                  ),
                );
              default:
                return const Center(child: Text('An error occurred'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Task',
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateTaskPage(subject: widget.subject),
        )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
