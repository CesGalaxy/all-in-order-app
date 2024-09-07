import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/modules/event/modals/create.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectCalendarGeneralView extends StatefulWidget {
  const SubjectCalendarGeneralView({super.key, required this.subjectId});

  final int subjectId;

  @override
  State<SubjectCalendarGeneralView> createState() =>
      _SubjectCalendarGeneralViewState();
}

class _SubjectCalendarGeneralViewState
    extends State<SubjectCalendarGeneralView> {
  @override
  Widget build(BuildContext context) {
    return CacheHandler(
      collection: Provider.of<CachedCollection<SubjectEvent>>(context),
      errorAction: (_) => _refreshEvents(),
      errorDetails: (error) => error.toString(),
      emptyActionLabel: "Create Event",
      emptyAction: _showCreateEventModal,
      builder: (context, events, _) {
        return Text(events.length.toString());
      },
    );
  }

  void _showCreateEventModal() async {
    final created = await showCreateEventModal(context, widget.subjectId);

    if (created && mounted) _refreshEvents();
  }

  void _refreshEvents() {
    Provider.of<CachedCollection<SubjectEvent>>(context, listen: false)
        .refresh(force: true);
  }
}
