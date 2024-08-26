import 'package:all_in_order/db/models/project.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/cached_collection.dart';
import '../../db/models/project_task.dart';
import '../task/create_page.dart';
import '../task/view_modal.dart';

class ProjectTasksPage extends StatefulWidget {
  const ProjectTasksPage({super.key, required this.project});

  final Project project;

  @override
  State<ProjectTasksPage> createState() => _ProjectTasksPageState();
}

class _ProjectTasksPageState extends State<ProjectTasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<CachedCollection<ProjectTask>>(context).fetch(),
        builder: (context, snapshot) => Consumer<CachedCollection<ProjectTask>>(
          builder: (context, tasksCache, child) {
            switch (tasksCache.status) {
              case CachedDataStatus.initializing:
                return const Center(child: CircularProgressIndicator());
              case CachedDataStatus.error:
                return const Center(child: Text('An error occurred'));
              case CachedDataStatus.done:
                final tasks = tasksCache.items;

                if (tasks.isEmpty) {
                  // Show a Card with action
                  return Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('No tasks found'),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CreateTaskPage(
                                    project: widget.project,
                                  ),
                                ));
                              },
                              child: const Text('Create Task'),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        subtitle: Text(task.description ?? "No description"),
                        onTap: () async {
                          await showTaskViewModal(context, task);
                          if (mounted) {
                            Provider.of<CachedCollection<ProjectTask>>(context,
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
          builder: (context) => CreateTaskPage(project: widget.project),
        )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
