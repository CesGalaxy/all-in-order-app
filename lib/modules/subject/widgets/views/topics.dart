import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/topic.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/topic/widgets/providers.dart';
import 'package:all_in_order/modules/topic/widgets/views/create_page.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectTopicsPage extends StatelessWidget {
  const SubjectTopicsPage({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CacheHandler(
        collection: Provider.of<CachedCollection<Topic>>(context),
        errorAction: (_) {},
        errorDetails: (error) => error.toString(),
        emptyTitle: S.of(context).noTopicsFound,
        emptyActionLabel: S.of(context).createTopic,
        emptyAction: () => _openTopicCreationPage(context),
        builder: (context, topics, _) => ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return ListTile(
              title: Text(topic.title),
              subtitle: Text(topic.description),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TopicProviders(
                          topic: topic,
                          subject: subject,
                        )),
              ),
              // leading: const Icon(Icons.topic),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openTopicCreationPage(context),
        icon: const Icon(Icons.add),
        label: Text(S.of(context).createTopic),
      ),
    );
  }

  Future _openTopicCreationPage(BuildContext context) async {
    final created = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TopicCreationPage(subjectId: subject.id),
    ));

    if (created != null && context.mounted) {
      Provider.of<CachedCollection<Topic>>(context, listen: false)
          .refresh(force: true);
    }
  }
}
