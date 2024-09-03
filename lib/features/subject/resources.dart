import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/widgets/empty_collection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/models/topic.dart';
import '../topic/create_page.dart';
import '../topic/navigation.dart';

class SubjectResourcesPage extends StatefulWidget {
  const SubjectResourcesPage({super.key, required this.subject});

  final Subject subject;

  @override
  State<SubjectResourcesPage> createState() => _SubjectResourcesPageState();
}

class _SubjectResourcesPageState extends State<SubjectResourcesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Topics'),
          Tab(text: 'Saved'),
          Tab(text: 'Notes'),
        ],
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          FutureBuilder(
            future: Provider.of<CachedCollection<Topic>>(context).fetch(),
            builder: (context, snapshot) => Consumer<CachedCollection<Topic>>(
              builder: (context, topicsCache, child) {
                switch (topicsCache.status) {
                  case CachedDataStatus.initializing:
                    return const Center(child: CircularProgressIndicator());
                  case CachedDataStatus.error:
                    return Center(child: Text('Error: ${topicsCache.error}'));
                  case CachedDataStatus.done:
                    final topics = topicsCache.items
                        .where((topic) => topic.subjectId == widget.subject.id)
                        .toList();

                    if (topics.isEmpty) {
                      // Show a Card with action
                      return EmptyCollectionScreen(
                        title: 'No topics found',
                        actionLabel: 'Create Topic',
                        action: _openTopicCreationPage,
                      );
                    }

                    return ListView.builder(
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        final topic = topics[index];
                        return ListTile(
                          title: Text(topic.title),
                          subtitle: Text(topic.description),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopicNavigation(topic: topic),
                            ),
                          ),
                          // leading: const Icon(Icons.topic),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.chat)),
                        );
                      },
                    );
                }
              },
            ),
          ),
          const Text("No data"),
          const Text("No data"),
          // ListView.builder(
          //   itemCount: widget.subject.saved.length,
          //   itemBuilder: (context, index) {
          //     final saved = widget.subject.saved[index];
          //     return ListTile(
          //       title: Text(saved.title),
          //       subtitle: Text(saved.description),
          //     );
          //   },
          // ),
          // ListView.builder(
          //   itemCount: widget.subject.notes.length,
          //   itemBuilder: (context, index) {
          //     final note = widget.subject.notes[index];
          //     return ListTile(
          //       title: Text(note.title),
          //       subtitle: Text(note.description),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  void _openTopicCreationPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => TopicCreationPage(subjectId: widget.subject.id),
    ))
        .then((value) {
      if (value != null && mounted) {
        Provider.of<CachedCollection<Topic>>(context, listen: false)
            .fetch(force: true);
      }
    });
  }
}
