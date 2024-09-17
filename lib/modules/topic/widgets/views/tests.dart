import 'package:all_in_order/db/models/topic_test.dart';
import 'package:all_in_order/modules/topic_test/widgets/navigation.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicTestsPage extends StatelessWidget {
  const TopicTestsPage({super.key});

  @override
  Widget build(BuildContext context) => CacheHandler(
        collection:
            Provider.of<CachedCollection<TopicTestWithQuestions>>(context),
        errorAction: (_) {},
        errorDetails: (error) => error.toString(),
        emptyActionLabel: "Create Test",
        emptyAction: () {},
        builder: (context, tests, _) => ListView.builder(
          itemCount: tests.length,
          itemBuilder: (context, index) {
            final test = tests[index];

            return ListTile(
              title: Text(test.name),
              subtitle: Text(test.description ?? ""),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TopicTestNavigation(test: test))),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
              ),
            );
          },
        ),
      );
}
