import 'package:all_in_order/features/note/edit_modal.dart';
import 'package:flutter/material.dart';

import '../../db/models/project_note.dart';

Future<bool> showNoteModal(BuildContext context, ProjectNote note) async {
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
            title: Text(note.title),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => {
                  showNoteEditModal(context, note).then((value) {
                    edited = true;
                  }),
                },
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
