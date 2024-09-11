import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/topic.dart';
import 'package:all_in_order/db/models/topic_test.dart';
import 'package:all_in_order/db/storage/topic_document.dart';
import 'package:all_in_order/modules/topic/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TopicProviders extends StatelessWidget {
  TopicProviders({
    super.key,
    required this.topic,
    required this.subject,
  })  : _docs = CachedCollection<FileObject>(
          fetch: () => getTopicDocuments(topic.id),
          cacheDuration: const Duration(minutes: 5),
        ),
        _tests = CachedCollection<TopicTest>(
          fetch: () => TopicTest.fetchByTopic(topic.id),
          cacheDuration: const Duration(minutes: 5),
        );

  final Topic topic;
  final Subject subject;

  final CachedCollection<FileObject> _docs;
  final CachedCollection<TopicTest> _tests;

  @override
  Widget build(BuildContext context) {
    _docs.refresh();
    _tests.refresh();

    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: subject.color,
          brightness: MediaQuery.platformBrightnessOf(context),
        ),
      ),
      child: MultiProvider(
        providers: [
          Provider.value(value: topic),
          ChangeNotifierProvider.value(value: _docs),
          ChangeNotifierProvider.value(value: _tests),
        ],
        child: const TopicNavigation(),
      ),
    );
  }
}
