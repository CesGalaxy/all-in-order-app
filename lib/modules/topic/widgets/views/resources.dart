import 'package:all_in_order/db/models/topic.dart';
import 'package:all_in_order/modules/docs/widgets/viewer.dart';
import 'package:all_in_order/modules/topic/widgets/views/file_details.dart';
import 'package:all_in_order/supabase.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return CacheHandler(
      collection: Provider.of<CachedCollection<FileObject>>(context),
      errorAction: (_) {},
      errorDetails: (error) => error.toString(),
      emptyActionLabel: "Create or upload a new document",
      emptyAction: () {},
      builder: (context, docs, _) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: const TabBar(
            tabs: [
              Tab(text: 'Documents'),
              Tab(text: 'Mind maps'),
              Tab(text: 'Other'),
            ],
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  return ListTile(
                    leading: const Icon(Icons.article),
                    title: Text(doc.name),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DocViewer(
                          name: doc.name,
                          downloadDoc: () => supabase.storage
                              .from("topic_documents")
                              .download("${widget.topic.id}/${doc.name}"),
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () => _showDocumentDetails(doc),
                    ),
                  );
                },
              ),
              Text('Mind maps'),
              Text('Other'),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentDetails(FileObject doc) {
    showModalBottomSheet(
      context: context,
      builder: (context) => FileDetails(
        file: doc,
        onEdit: () {},
        onDelete: () {},
      ),
    );
  }
}
