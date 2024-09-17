import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectAgendaToday extends StatelessWidget {
  const SubjectAgendaToday({super.key});

  @override
  Widget build(BuildContext context) {
    return CacheHandler(
      collection: Provider.of<CachedCollection<SubjectEvent>>(context),
      errorAction: (_) {},
      errorDetails: (error) => error.toString(),
      emptyActionLabel: S.of(context).createEvent,
      emptyAction: () {},
      builder: (context, events, _) {
        final todayEvents =
            events.where((event) => event.isInDay(DateTime.now())).toList();

        if (todayEvents.isEmpty) {
          return Center(child: Text(S.of(context).noEventsToday));
        }

        return ListView.builder(
          itemCount: todayEvents.length,
          itemBuilder: (context, index) {
            final event = todayEvents[index];

            return ListTile(
              title: Text(event.title),
              subtitle: Text(event.details ?? S.of(context).noDescription),
              onTap: () {},
              trailing: IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {},
              ),
            );
          },
        );
      },
    );
  }
}
