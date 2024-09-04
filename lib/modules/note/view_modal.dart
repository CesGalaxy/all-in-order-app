import 'package:all_in_order/modules/note/edit_modal.dart';
import 'package:flutter/material.dart';

import '../../db/models/subject_note.dart';

Future<bool> showNoteModal(
  BuildContext context,
  SubjectNote note, {
  bool allowEditing = false,
}) async {
  bool edited = false;

  await showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text(note.title ?? 'Untitled'),
            backgroundColor: Colors.transparent,
            actions: [
              if (allowEditing)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      showNoteEditModal(context, note).then((_) {
                    edited = true;
                    Navigator.of(context).pop();
                  }),
                ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {},
              ),
            ],
          ),
          if (note.content != null)
            Text(note.content!, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          if (note.tags != null)
            Wrap(
              spacing: 4,
              children: note.tags!
                  .map((tag) => Chip(
                        label: Text(tag,
                            style: Theme.of(context).textTheme.labelSmall),
                        padding: const EdgeInsets.all(0.0),
                      ))
                  .toList(),
            ),
        ],
      ),
    ),
  );

  return edited;
}
