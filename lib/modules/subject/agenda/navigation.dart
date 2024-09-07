import 'package:all_in_order/modules/subject/agenda/today.dart';
import 'package:flutter/material.dart';

class SubjectAgendaNavigation extends StatefulWidget {
  const SubjectAgendaNavigation({super.key});

  @override
  State<SubjectAgendaNavigation> createState() =>
      _SubjectAgendaNavigationState();
}

class _SubjectAgendaNavigationState extends State<SubjectAgendaNavigation> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: TabBar(
          tabs: [
            Tab(text: 'Past'),
            Tab(text: 'Today'),
            Tab(text: 'Future'),
          ],
        ),
        body: TabBarView(
          children: [
            Text('Past'),
            SubjectAgendaToday(),
            Text('Future'),
          ],
        ),
      ),
    );
  }
}
