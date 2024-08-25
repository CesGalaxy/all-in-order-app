import 'package:all_in_order/db/models/project_note.dart';
import 'package:all_in_order/features/note/view_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../db/models/project.dart';

class ProjectHome extends StatelessWidget {
  const ProjectHome(
      {super.key, required this.project, required this.setTitleVisibility});

  final Project project;
  final void Function(bool) setTitleVisibility;

  @override
  Widget build(BuildContext context) {
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
          _latestNotes(),
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
                  project.name,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  project.resume,
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

  Widget _latestNotes() {
    return FutureBuilder(
      future: ProjectNote.fetchByProject(project.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("An error occurred"));
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
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
            children: snapshot.data!
                .map((note) => Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () =>
                            showNoteModal(context, note).then((edited) {
                            // TODO: Refresh the stateless widget
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: Theme.of(context).textTheme.bodyLarge,
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
                                            padding: const EdgeInsets.all(0.0),
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
      },
    );
  }
}
