import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_note.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/note/modals/view_modal.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectLatestNotes extends StatelessWidget {
  final Subject subject;
  final Function showCreateNoteModal;

  const SubjectLatestNotes({
    super.key,
    required this.subject,
    required this.showCreateNoteModal,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 96,
        child: CacheHandler(
          collection: Provider.of<CachedCollection<SubjectNote>>(context),
          errorAction: (error) {},
          errorDetails: (error) => error.toString(),
          emptyActionLabel: S.of(context).createANewNote,
          emptyAction: () => showCreateNoteModal(context),
          builder: (BuildContext context, List<SubjectNote> notes, Widget? _) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: notes.length,
              itemBuilder: (context, index) => _noteCard(context, notes[index]),
            );
          },
        ),
      );

  Widget _noteCard(BuildContext context, SubjectNote note) => Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () async {
            final edited =
                await showNoteModal(context, note, allowEditing: true);

            if (edited && context.mounted) {
              Provider.of<CachedCollection<SubjectNote>>(context, listen: false)
                  .refresh(force: true);
            }
          },
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
