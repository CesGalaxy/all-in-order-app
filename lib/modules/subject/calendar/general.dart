import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/event/modals/create.dart';
import 'package:all_in_order/modules/subject/calendar/utils.dart';
import 'package:all_in_order/modules/task/widgets/modals/view_modal.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class SubjectCalendarGeneralView extends StatefulWidget {
  const SubjectCalendarGeneralView(
      {super.key, required this.subjectId, required this.events});

  final int subjectId;
  final List<SubjectEvent> events;

  @override
  State<SubjectCalendarGeneralView> createState() =>
      _SubjectCalendarGeneralViewState();
}

class _SubjectCalendarGeneralViewState
    extends State<SubjectCalendarGeneralView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  late List<SubjectEvent> _selectedEvents =
      getEventsForDay(_selectedDay, widget.events);

  @override
  void initState() {
    _selectedEvents = getEventsForDay(_selectedDay, widget.events);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CacheHandler(
      collection: Provider.of<CachedCollection<SubjectEvent>>(context),
      errorAction: (_) => _refreshEvents(),
      errorDetails: (error) => error.toString(),
      emptyActionLabel: S.of(context).createEvent,
      emptyAction: _showCreateEventModal,
      builder: (context, events, _) => ListView(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(selectedDay, _selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents = getEventsForDay(selectedDay, events);
                });
              }
            },
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            eventLoader: (day) => getEventsForDay(day, events),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) =>
                setState(() => _calendarFormat = format),
          ),
          const Divider(),
          if (_selectedEvents.isEmpty)
            ListTile(title: Text(S.of(context).noEvents))
          else
            ..._selectedEvents.map(_eventTile),
          const SizedBox(height: kToolbarHeight + 1)
        ],
      ),
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

  Widget _eventTile(SubjectEvent event) {
    return ListTile(
      title: Text(event.title),
      subtitle: event.details != null ? Text(event.details!) : null,
      onTap: () {
        if (event.type == SubjectEventType.task) {
          _showTaskModal(event);
        }
      },
      leading: Icon(event.type.icon),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          if (event.type == SubjectEventType.task) {
            _showTaskModal(event, true);
          }
        },
      ),
    );
  }

  _showTaskModal(SubjectEvent task, [bool editMode = false]) async {
    if (await showTaskViewModal(context, task, editMode) == true && mounted) {
      Provider.of<CachedCollection<SubjectEvent>>(context, listen: false)
          .refresh(force: true);
    }
  }
}
