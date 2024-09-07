import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/db/models/subject_task.dart';
import 'package:all_in_order/modules/task/create_page.dart';
import 'package:all_in_order/modules/task/view_modal.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: CacheHandler<SubjectEvent>(
        collection: Provider.of<CachedCollection<SubjectEvent>>(context),
        errorDetails: (error) => error.toString(),
        errorAction: (_) {},
        emptyTitle: "No tasks found",
        emptyActionLabel: "Create Task",
        emptyAction: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateTaskPage(subject: widget.subject))),
        builder: (context, tasks, _) => RefreshIndicator(
          onRefresh: () => Provider.of<CachedCollection<SubjectEvent>>(
            context,
            listen: false,
          ).refresh(force: true),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task =
                  tasks.where((task) => task.type == 'TASK').toList()[index];

              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.details ?? "No description"),
                onTap: () async {
                  await showTaskViewModal(context, task);

                  if (context.mounted) {
                    Provider.of<CachedCollection<SubjectTask>>(
                      context,
                      listen: false,
                    ).refresh(force: true);
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
