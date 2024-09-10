import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/topic.dart';
import 'package:all_in_order/db/storage/topic_document.dart';
import 'package:all_in_order/modules/topic/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TopicProviders extends StatelessWidget {
  TopicProviders({
    super.key,
    required this.topic,
    required this.subjectColor,
  }) : _docs = CachedCollection<FileObject>(
          fetch: () => getTopicDocuments(topic.id),
          cacheDuration: const Duration(minutes: 5),
        );

  final Topic topic;
  final Color subjectColor;

  final CachedCollection<FileObject> _docs;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: subjectColor)),
      child: MultiProvider(
        providers: [
          Provider.value(value: topic),
          ChangeNotifierProvider.value(value: _docs),
        ],
        child: const TopicNavigation(),
      ),
    );
  }
}
