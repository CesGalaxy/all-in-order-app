import 'package:all_in_order/api/cached_map.dart';
import 'package:all_in_order/db/models/project_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsProvider extends StatefulWidget {
  const EventsProvider({super.key, required this.child});
  final Widget child;

  @override
  State<EventsProvider> createState() => _EventsProviderState();
}

class _EventsProviderState extends State<EventsProvider> {
  late final CachedMap<int, ProjectEvent> _events = CachedMap<int, ProjectEvent>(
    fetchOneRequest: (id) async => (id, (await ProjectEvent.fetchById(id))!),
    fetchSomeRequest: (ids) async {
      final data = await ProjectEvent.fetchManyByIds(ids);

      return { for (var event in data!) event.id: event };
    },
    cacheDuration: const Duration(minutes: 5),
  );

  @override
  void initState() {
    // _projectNotes.fetch(force: true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _events,
      child: widget.child,
    );
  }
}
