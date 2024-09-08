import 'package:all_in_order/generated/l10n.dart';
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
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: TabBar(
          tabs: [
            Tab(text: S.of(context).past),
            Tab(text: S.of(context).today),
            Tab(text: S.of(context).future),
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
