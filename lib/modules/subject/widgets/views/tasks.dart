import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/event/modals/create_task.dart';
import 'package:all_in_order/modules/task/widgets/modals/view_modal.dart';
import 'package:all_in_order/utils/cached_collection.dart';
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
        emptyTitle: S.of(context).noTasksFound,
        emptyActionLabel: S.of(context).createTask,
        emptyAction: () => _pushCreateTaskPage(),
        builder: (context, tasks, _) => RefreshIndicator(
          onRefresh: () => Provider.of<CachedCollection<SubjectEvent>>(
            context,
            listen: false,
          ).refresh(force: true),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks
                  .where((task) => task.type == SubjectEventType.task)
                  .toList()[index];

              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.details ?? S.of(context).noDescription),
                onTap: () async {
                  final edited = await showTaskViewModal(context, task);

                  if (edited == true && context.mounted) {
                    Provider.of<CachedCollection<SubjectEvent>>(context,
                            listen: false)
                        .refresh(force: true);
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
        tooltip: S.of(context).createTask,
        onPressed: () => _pushCreateTaskPage(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _pushCreateTaskPage() async {
    final created = await pushCreateTaskPage(context, widget.subject.id);

    if (created && mounted) {
      Provider.of<CachedCollection<SubjectEvent>>(context, listen: false)
          .refresh(force: true);
    }
  }
}
