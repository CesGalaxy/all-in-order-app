import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_note.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/note/modals/create_modal.dart';
import 'package:all_in_order/modules/note/modals/view_modal.dart';
import 'package:all_in_order/modules/subject/widgets/views/note_card.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectHome extends StatelessWidget {
  const SubjectHome(
      {super.key, required this.subject, required this.setTitleVisibility});

  final Subject subject;
  final void Function(bool) setTitleVisibility;

  @override
  Widget build(BuildContext context) {
    Provider.of<CachedCollection<SubjectNote>>(context, listen: false)
        .refresh();

    return Scaffold(
      body: ListView(
        children: [
          _hero(context),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).latestNotes,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: () => _showCreateNoteModal(context),
                  icon: const Icon(Icons.post_add),
                )
              ],
            ),
          ),
          _latestNotes(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.of(context).nextEvents,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          ClipRect(
            child: OverflowBox(
              maxWidth: MediaQuery.of(context).size.width,
              minWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height,
              child: Image.network(
                  'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_1.png'),
            ),
          ),
          // Dark transparent gradient background
          Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[Color(0x10000000), Color(0x80000000)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  subject.name,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.white),
                ),
                if (subject.description != null) const SizedBox(height: 10),
                if (subject.description != null)
                  Text(
                    subject.description!,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _latestNotes(BuildContext context) {
    return SizedBox(
      height: 96,
      child: CacheHandler(
        collection: Provider.of<CachedCollection<SubjectNote>>(context),
        errorAction: (error) {},
        errorDetails: (error) => error.toString(),
        emptyActionLabel: S.of(context).createANewNote,
        emptyAction: () => _showCreateNoteModal(context),
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

  Future _showCreateNoteModal(BuildContext context) async {
    await showCreateNoteModal(context, subject.id);
    if (context.mounted) {
      Provider.of<CachedCollection<SubjectNote>>(context, listen: false)
          .refresh(force: true);
    }
  }
}
