import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/project.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../db/models/agenda.dart';
import '../../../db/models/project_event.dart';

class ProjectCalendarPage extends StatefulWidget {
  final Project project;

  const ProjectCalendarPage({super.key, required this.project});

  @override
  State<ProjectCalendarPage> createState() => _ProjectCalendarPageState();
}

class _ProjectCalendarPageState extends State<ProjectCalendarPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 4, vsync: this, initialIndex: 3);
  final EventController _eventController = EventController();

  int _activeView = 3;

  final List<int> _disabledAgendas = [];

  List<ProjectEvent>? _events;

  @override
  Widget build(BuildContext context) {
    //   return Scaffold(
    //     body: Row(
    //       children: [
    //         NavigationRail(
    //           labelType: NavigationRailLabelType.all,
    //           selectedIndex: _activeView,
    //           onDestinationSelected: (int index) =>
    //               setState(() => _activeView = index),
    //           leading: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: CircleAvatar(
    //               child: Text(widget.project.name[0]),
    //             ),
    //           ),
    //           destinations: const <NavigationRailDestination>[
    //             NavigationRailDestination(
    //               icon: Icon(Icons.calendar_month_outlined),
    //               selectedIcon: Icon(Icons.calendar_month),
    //               label: Text('Month'),
    //             ),
    //             NavigationRailDestination(
    //               icon: Icon(Icons.calendar_today_outlined),
    //               selectedIcon: Icon(Icons.calendar_today),
    //               label: Text('Week'),
    //             ),
    //             NavigationRailDestination(
    //               icon: Icon(Icons.calendar_view_day_outlined),
    //               selectedIcon: Icon(Icons.calendar_view_day),
    //               label: Text('Day'),
    //             ),
    //             NavigationRailDestination(
    //               icon: Icon(Icons.view_agenda_outlined),
    //               selectedIcon: Icon(Icons.view_agenda),
    //               label: Text('Agenda'),
    //             ),
    //           ],
    //         ),
    //         const VerticalDivider(thickness: 1, width: 1),
    //         const Expanded(child: Center(child: Text('Calendar')))
    //       ],
    //     ),
    //   );

    final agendasCache = Provider.of<CachedCollection<Agenda>>(context);

    if (agendasCache.status == CachedDataStatus.initializing) {
      return const Center(child: CircularProgressIndicator());
    } else if (agendasCache.status == CachedDataStatus.error) {
      return Center(
        child: ActionChip(
          avatar: const Icon(Icons.error, color: Colors.white),
          label: const Text(
            "An error occurred",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          onPressed: () {
            agendasCache.fetch(force: true);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(agendasCache.error!.toString())),
            );
          },
        ),
      );
    }

    // Get agendas but exclude the disabled ones
    final selectedAgendas = agendasCache.items
        .where((agenda) => !_disabledAgendas.contains(agenda.id))
        .toList();

    _events = _events ?? selectedAgendas.expand((agenda) => agenda.events).toList();

    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(icon: Icon(Icons.calendar_month_outlined)),
              Tab(icon: Icon(Icons.calendar_today_outlined)),
              Tab(icon: Icon(Icons.calendar_view_day_outlined)),
              Tab(icon: Icon(Icons.view_agenda_outlined)),
            ],
            onTap: (index) => setState(() => _activeView = index),
          ),
          Expanded(
            child: Scaffold(
              body: <Widget>[
                MonthView(
                  controller: _eventController,
                  showWeekTileBorder: false,
                ),
                WeekView(
                  controller: _eventController,
                ),
                DayView(
                  controller: _eventController,
                ),
                ListView.builder(
                  itemCount: selectedAgendas.length,
                  itemBuilder: (context, index) {
                    final agenda = selectedAgendas[index];
                    return ListTile(
                      title: Text(agenda.name),
                      subtitle: Text(agenda.resume ?? ""),
                    );
                  },
                ),
              ][_activeView],
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              scrollDirection: Axis.horizontal,
              itemCount: agendasCache.items.length,
              itemBuilder: (context, index) => FilterChip(
                label: Text(agendasCache.items[index].name),
                selected:
                    !_disabledAgendas.contains(agendasCache.items[index].id),
                onSelected: (bool value) => setState(() {
                  if (value) {
                    _disabledAgendas.remove(agendasCache.items[index].id);
                  } else {
                    _disabledAgendas.add(agendasCache.items[index].id);
                  }
                }),
              ),
              separatorBuilder: (context, index) => const SizedBox(width: 8),
            ),
          ),
        ],
      ),
    );
  }
}
