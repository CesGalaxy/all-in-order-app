import 'package:all_in_order/db/models/subject_note.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.action,
  });

  final SubjectNote note;
  final Function()? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title ?? S.of(context).untitled,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (note.tags != null)
                Wrap(
                  spacing: 4,
                  children: note.tags!
                      .map((tag) => Chip(
                            label: Text(
                              tag,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            padding: const EdgeInsets.all(0.0),
                          ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
