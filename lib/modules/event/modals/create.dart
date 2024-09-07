import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/modules/event/modals/create_task.dart';
import 'package:flutter/material.dart';

Future<bool> showCreateEventModal(BuildContext context, int subjectId) async {
  final selectorResult = await showEventTypeSelector(context);

  if (!context.mounted) return false;

  switch (selectorResult) {
    case null:
      return false;
    case SubjectEventType.event:
      return false;
    case SubjectEventType.task:
      return pushCreateTaskPage(context, subjectId);
    case SubjectEventType.reminder:
      return false;
    case SubjectEventType.other:
      return false;
  }
}

Future<SubjectEventType?> showEventTypeSelector(BuildContext context) {
  return showDialog<SubjectEventType>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Event Type'),
      children: SubjectEventType.values
          .map((type) => SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop(type);
                },
                child: Text(type.toString().split('.').last),
              ))
          .toList(),
    ),
  );
}
