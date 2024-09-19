import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/topic.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/topic/widgets/providers.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectTopicsCarrousel extends StatelessWidget {
  final Subject subject;

  const SubjectTopicsCarrousel({super.key, required this.subject});

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 96),
        child: CacheHandler(
          collection: Provider.of<CachedCollection<Topic>>(context),
          errorAction: (_) {},
          emptyActionLabel: S.of(context).createTopic,
          emptyAction: () {},
          builder: (context, topics, _) => CarouselView.weighted(
            flexWeights: const [1, 7, 1],
            onTap: (index) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TopicProviders(
                        topic: topics[index],
                        subject: subject,
                      )),
            ),
            children: topics
                .map((topic) => _topicCard(context, topic))
                .toList(growable: false),
          ),
        ),
      );

  Widget _topicCard(BuildContext context, Topic topic) => ColoredBox(
        color: Colors.primaries[topic.id % Colors.primaries.length]
            .withOpacity(0.5),
        child: Center(
          child: Text(
            topic.title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      );
}
