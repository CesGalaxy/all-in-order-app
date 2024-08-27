import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/api/cached_map.dart';
import 'package:all_in_order/db/models/agenda.dart';
import 'package:all_in_order/db/models/project_event.dart';
import 'package:all_in_order/db/models/project_task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/models/project.dart';
import '../../db/models/project_note.dart';
import 'navigation.dart';

class ProjectProviders extends StatefulWidget {
  const ProjectProviders({super.key, required this.project});

  final Project project;

  @override
  State<ProjectProviders> createState() => _ProjectProvidersState();
}

class _ProjectProvidersState extends State<ProjectProviders> {
  late CachedCollection<ProjectNote> _projectNotes =
      CachedCollection<ProjectNote>(
    fetch: () async => (await ProjectNote.fetchByProject(widget.project.id))!,
    cacheDuration: const Duration(minutes: 5),
  );

  late CachedCollection<ProjectTask> _projectTasks =
      CachedCollection<ProjectTask>(
    fetch: () async => (await ProjectTask.fetchByProject(widget.project.id))!,
    cacheDuration: const Duration(minutes: 5),
  );

  late CachedCollection<Agenda> _projectAgendas = CachedCollection<Agenda>(
    fetch: () async => (await Agenda.fetchByProject(widget.project.id))!,
    cacheDuration: const Duration(minutes: 5),
  );

  @override
  void initState() {
    _projectNotes = CachedCollection<ProjectNote>(
      fetch: () async => (await ProjectNote.fetchByProject(widget.project.id))!,
      cacheDuration: const Duration(minutes: 5),
    );

    _projectTasks = CachedCollection<ProjectTask>(
      fetch: () async => (await ProjectTask.fetchByProject(widget.project.id))!,
      cacheDuration: const Duration(minutes: 5),
    );

    _projectAgendas = CachedCollection<Agenda>(
      fetch: () async => (await Agenda.fetchByProject(widget.project.id))!,
      cacheDuration: const Duration(minutes: 5),
    );
    // _projectNotes.fetch(force: true);
    super.initState();
  }

  @override
  void dispose() {
    _projectNotes.dispose();
    _projectTasks.dispose();
    _projectAgendas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _projectNotes.fetch();
    _projectTasks.fetch();
    _projectAgendas.fetch();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _projectNotes),
        ChangeNotifierProvider.value(value: _projectTasks),
        ChangeNotifierProvider.value(value: _projectAgendas),
      ],
      child: ProjectNavigation(project: widget.project),
    );
  }
}
