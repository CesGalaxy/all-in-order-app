import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_note.dart';
import 'package:all_in_order/features/note/view_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectHome extends StatelessWidget {
  const SubjectHome(
      {super.key, required this.subject, required this.setTitleVisibility});

  final Subject subject;
  final void Function(bool) setTitleVisibility;

  @override
  Widget build(BuildContext context) {
    Provider.of<CachedCollection<SubjectNote>>(context, listen: false).fetch();

    return Scaffold(
      body: ListView(
        children: [
          _hero(context),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Latest Notes",
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          _latestNotes(
            context,
            () => Provider.of<CachedCollection<SubjectNote>>(context,
                    listen: false)
                .refresh(force: true),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Next Events",
                style: Theme.of(context).textTheme.headlineMedium),
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
                colors: <Color>[
                  Color(0x10000000),
                  Color(0x80000000),
                ],
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
                if (subject.description != null)
                  const SizedBox(height: 10),
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

  Widget _latestNotes(BuildContext context, Function refresh) {
    return Consumer<CachedCollection<SubjectNote>>(
      builder: (context, notes, child) {
        switch (notes.status) {
          case CachedDataStatus.initializing:
            return const Center(child: CircularProgressIndicator());
          case CachedDataStatus.error:
            return Center(
              child: ActionChip(
                avatar: const Icon(Icons.error, color: Colors.white),
                label: const Text(
                  "An error occurred",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
                onPressed: () {
                  notes.fetch(force: true);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(notes.error!.toString()),
                    ),
                  );
                },
              ),
            );
          case CachedDataStatus.done:
            if (notes.items.isEmpty) {
              return Center(
                child: FilledButton(
                  onPressed: () {},
                  child: const Text("Create a new note"),
                ),
              );
            }

            return SizedBox(
              height: 96,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                children: notes.items
                    .map((note) => Card(
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () =>
                                showNoteModal(context, note, allowEditing: true)
                                    .then((edited) {
                              if (edited) {
                                refresh();
                              }
                              // TODO: Refresh the stateless widget
                            }),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title ?? "Untitled",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  if (note.tags != null)
                                    Wrap(
                                      spacing: 4,
                                      children: note.tags!
                                          .map((tag) => Chip(
                                                label: Text(tag,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall),
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                              ))
                                          .toList(),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            );
        }
      },
    );
  }
}
