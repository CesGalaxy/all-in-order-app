import 'package:all_in_order/db/models/topic.dart';
import 'package:all_in_order/db/storage/topic_document.dart';
import 'package:all_in_order/modules/docs/widgets/viewer.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TopicResources extends StatefulWidget {
  const TopicResources({super.key, required this.topic});

  final Topic topic;

  @override
  State<TopicResources> createState() => _TopicResourcesState();
}

class _TopicResourcesState extends State<TopicResources> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: const TabBar(
            tabs: [
              Tab(text: 'Documents'),
              Tab(text: 'Mind maps'),
              Tab(text: 'Other'),
            ],
          ),
          body: TabBarView(children: [
            FutureBuilder<List<FileObject>>(
              future: getTopicDocuments(widget.topic.id),
              builder: (context, snapshot) =>
                  (snapshot.hasData && snapshot.data!.isNotEmpty)
                      ? ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final doc = snapshot.data![index];
                            return ListTile(
                              leading: const Icon(Icons.article),
                              title: Text(doc.name),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DocViewer(doc: doc),
                                ),
                              ),
                              trailing: IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () async {}),
                            );
                          },
                        )
                      // TODO: Handle loading and error
                      : Center(
                          child: FilledButton(
                            onPressed: () {},
                            child: const Text('Create a new document'),
                          ),
                        ),
            ),
            Text('Articles'),
            Text('Books'),
          ]),
        ));
  }
}
