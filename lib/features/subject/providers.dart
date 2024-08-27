import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/db/models/subject_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/cached_collection.dart';
import '../../db/models/subject_note.dart';
import 'navigation.dart';

class SubjectProviders extends StatefulWidget {
  const SubjectProviders({super.key, required this.subject});

  final Subject subject;

  @override
  State<SubjectProviders> createState() => _SubjectProvidersState();
}

class _SubjectProvidersState extends State<SubjectProviders> {
  late CachedCollection<SubjectNote> _subjectNotes =
      CachedCollection<SubjectNote>(
    fetch: () async => (await SubjectNote.fetchBySubject(widget.subject.id))!,
    cacheDuration: const Duration(minutes: 5),
  );

  // late CachedCollection<ProjectTask> _projectTasks =
  //     CachedCollection<ProjectTask>(
  //   fetch: () async => (await ProjectTask.fetchByProject(widget.project.id))!,
  //   cacheDuration: const Duration(minutes: 5),
  // );
  //
  late CachedCollection<SubjectEvent> _subjectEvents =
      CachedCollection<SubjectEvent>(
    fetch: () async => (await SubjectEvent.fetchBySubject(widget.subject.id))!,
    cacheDuration: const Duration(minutes: 5),
  );

  @override
  void initState() {
    _subjectNotes = CachedCollection<SubjectNote>(
      fetch: () async => (await SubjectNote.fetchBySubject(widget.subject.id))!,
      cacheDuration: const Duration(minutes: 5),
    );

    // _projectTasks = CachedCollection<ProjectTask>(
    //   fetch: () async => (await ProjectTask.fetchByProject(widget.project.id))!,
    //   cacheDuration: const Duration(minutes: 5),
    // );
    //
    _subjectEvents = CachedCollection<SubjectEvent>(
      fetch: () async =>
          (await SubjectEvent.fetchBySubject(widget.subject.id))!,
      cacheDuration: const Duration(minutes: 5),
    );
    _subjectNotes.fetch(force: true);
    super.initState();
  }

  @override
  void dispose() {
    _subjectNotes.dispose();
    // _projectTasks.dispose();
    _subjectEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _subjectNotes.fetch();
    // _projectTasks.fetch();
    _subjectEvents.fetch();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _subjectNotes),
        // ChangeNotifierProvider.value(value: _projectTasks),
        ChangeNotifierProvider.value(value: _subjectEvents),
      ],
      child: SubjectNavigation(subject: widget.subject),
    );
  }
}
