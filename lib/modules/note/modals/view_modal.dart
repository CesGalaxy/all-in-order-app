import 'package:all_in_order/modules/note/modals/edit_modal.dart';
import 'package:flutter/material.dart';

import '../../../db/models/subject_note.dart';

Future<bool> showNoteModal(
  BuildContext context,
  SubjectNote note, {
  bool allowEditing = false,
}) async {
  bool edited = false;

  await showModalBottomSheet(
    context: context,
    builder: (context) => ViewNoteModal(
      note: note,
      allowEditing: allowEditing,
      onEdit: () => edited = true,
    ),
  );

  return edited;
}

class ViewNoteModal extends StatelessWidget {
  final SubjectNote note;
  final bool allowEditing;
  final Function() onEdit;

  const ViewNoteModal({
    super.key,
    required this.note,
    required this.allowEditing,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                    onPressed: () => _showEditModal(context),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ],
            ),
            if (note.content != null)
              Text(note.content!,
                  style: Theme.of(context).textTheme.bodyMedium),
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
  }

  Future _showEditModal(BuildContext context) async {
    final edited = await showNoteEditModal(context, note);

    if (edited == true) {
      onEdit();
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
