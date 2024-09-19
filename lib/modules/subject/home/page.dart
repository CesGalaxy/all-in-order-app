import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_note.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/note/modals/create_modal.dart';
import 'package:all_in_order/modules/subject/home/hero.dart';
import 'package:all_in_order/modules/subject/home/latest_notes.dart';
import 'package:all_in_order/modules/subject/home/topics_carrousel.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectHome extends StatelessWidget {
  const SubjectHome({
    super.key,
    required this.subject,
    required this.setTitleVisibility,
    required this.goToTopics,
  });

  final Subject subject;
  final void Function(bool) setTitleVisibility;
  final void Function() goToTopics;

  @override
  Widget build(BuildContext context) {
    Provider.of<CachedCollection<SubjectNote>>(context, listen: false)
        .refresh();

    return Scaffold(
      body: ListView(
        children: [
          SubjectHero(subject: subject),
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
          SubjectLatestNotes(
            subject: subject,
            showCreateNoteModal: _showCreateNoteModal,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).topics,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: goToTopics,
                  icon: const Icon(Icons.arrow_forward),
                )
              ],
            ),
          ),
          SubjectTopicsCarrousel(subject: subject),
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

  Future _showCreateNoteModal(BuildContext context) async {
    await showCreateNoteModal(context, subject.id);
    if (context.mounted) {
      Provider.of<CachedCollection<SubjectNote>>(context, listen: false)
          .refresh(force: true);
    }
  }
}
