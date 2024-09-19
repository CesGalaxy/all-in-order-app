import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_note.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/note/modals/view_modal.dart';
import 'package:all_in_order/modules/subject/home/note_card.dart';
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
              itemBuilder: (context, index) {
                final note = notes[index];

                return NoteCard(
                  note: note,
                  action: () async {
                    final edited =
                        await showNoteModal(context, note, allowEditing: true);
                    if (edited && context.mounted) {
                      Provider.of<CachedCollection<SubjectNote>>(
                        context,
                        listen: false,
                      ).refresh(force: true);
                    }
                  },
                );
              },
            );
          },
        ),
      );
}
