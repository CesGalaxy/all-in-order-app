import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/db/models/subject_task.dart';
import 'package:all_in_order/db/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api/cached_collection.dart';
import '../../../db/models/subject_note.dart';
import './navigation.dart';

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

  late CachedCollection<SubjectTask> _subjectTasks =
      CachedCollection<SubjectTask>(
    fetch: () async => (await SubjectTask.fetchByProject(widget.subject.id))!,
    cacheDuration: const Duration(minutes: 5),
  );

  late CachedCollection<SubjectEvent> _subjectEvents =
      CachedCollection<SubjectEvent>(
    fetch: () async => (await SubjectEvent.fetchBySubject(widget.subject.id))!,
    cacheDuration: const Duration(minutes: 5),
  );

  late CachedCollection<Topic> _subjectTopics = CachedCollection<Topic>(
    fetch: () async => (await Topic.fetchBySubject(widget.subject.id))!,
    cacheDuration: const Duration(minutes: 5),
  );

  @override
  void initState() {
    _subjectNotes = CachedCollection<SubjectNote>(
      fetch: () async => (await SubjectNote.fetchBySubject(widget.subject.id))!,
      cacheDuration: const Duration(minutes: 5),
    );

    _subjectTasks = CachedCollection<SubjectTask>(
      fetch: () async => (await SubjectTask.fetchByProject(widget.subject.id))!,
      cacheDuration: const Duration(minutes: 5),
    );

    _subjectEvents = CachedCollection<SubjectEvent>(
      fetch: () async =>
          (await SubjectEvent.fetchBySubject(widget.subject.id))!,
      cacheDuration: const Duration(minutes: 5),
    );

    _subjectTopics = CachedCollection<Topic>(
      fetch: () async => (await Topic.fetchBySubject(widget.subject.id))!,
      cacheDuration: const Duration(minutes: 5),
    );

    super.initState();
  }

  @override
  void dispose() {
    _subjectNotes.dispose();
    _subjectTasks.dispose();
    _subjectEvents.dispose();
    _subjectTopics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _subjectNotes.fetch();
    _subjectTasks.fetch();
    _subjectEvents.fetch();
    _subjectTopics.fetch();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _subjectNotes),
        ChangeNotifierProvider.value(value: _subjectTasks),
        ChangeNotifierProvider.value(value: _subjectEvents),
        ChangeNotifierProvider.value(value: _subjectTopics),
      ],
      child: SubjectNavigation(subject: widget.subject),
    );
  }
}
