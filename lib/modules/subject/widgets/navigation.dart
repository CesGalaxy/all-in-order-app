import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/subject_event.dart';
import 'package:all_in_order/db/models/subject_note.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/event/modals/create.dart';
import 'package:all_in_order/modules/event/modals/create_task.dart';
import 'package:all_in_order/modules/note/modals/create_modal.dart';
import 'package:all_in_order/modules/subject/calendar/navigation.dart';
import 'package:all_in_order/modules/subject/widgets/views/home.dart';
import 'package:all_in_order/modules/subject/widgets/views/settings.dart';
import 'package:all_in_order/modules/subject/widgets/views/tasks.dart';
import 'package:all_in_order/modules/subject/widgets/views/topics.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectNavigation extends StatefulWidget {
  const SubjectNavigation({super.key, required this.subject});

  final Subject subject;

  @override
  State<SubjectNavigation> createState() => _SubjectNavigationState();
}

class _SubjectNavigationState extends State<SubjectNavigation>
    with SingleTickerProviderStateMixin {
  late PageController _pageViewController = PageController();
  late AnimationController _titleController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  int _activeIndex = 0;

  final bool _showTitle = false;

  late double width;
  late double height;

  @override
  void initState() {
    _pageViewController = PageController();
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _activeIndex != 0 || _showTitle ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Text(widget.subject.name),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    SubjectSettingsPage(subject: widget.subject),
              ),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.add),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                onTap: _showCreateNoteModal,
                child: ListTile(
                  leading: const Icon(Icons.note_add),
                  title: Text(S.of(context).addNote),
                ),
              ),
              PopupMenuItem(
                onTap: _pushCreateTaskPage,
                child: ListTile(
                  leading: const Icon(Icons.task),
                  title: Text(S.of(context).addTask),
                ),
              ),
              PopupMenuItem(
                onTap: _showCreateEventModal,
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(S.of(context).addEvent),
                ),
              ),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageViewController,
        children: <Widget>[
          SubjectHome(
              subject: widget.subject, setTitleVisibility: _setTitleVisibility),
          SubjectTopicsPage(subject: widget.subject),
          SubjectTasksPage(subject: widget.subject),
          //ProjectCalendarPage(subject: widget.subject),
          SubjectCalendarNavigation(subjectId: widget.subject.id),
          const Text("Hello world!"),
        ],
        onPageChanged: (index) {
          setState(() {
            _activeIndex = index;
            _titleController.forward(from: 0);
          });
        },
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _pageViewController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceOut,
            );
          });
        },
        selectedIndex: _activeIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: S.of(context).home,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.book),
            icon: const Icon(Icons.book_outlined),
            label: S.of(context).topics,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.task_alt),
            icon: const Icon(Icons.task_alt_outlined),
            label: S.of(context).tasks,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.calendar_month),
            icon: const Icon(Icons.calendar_month_outlined),
            label: S.of(context).calendar,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.people_alt),
            icon: const Icon(Icons.people_alt_outlined),
            label: S.of(context).team,
          ),
        ],
      ),
    );
  }

  void _setTitleVisibility(bool visible) {
    _titleController.animateTo(visible ? 1 : 0);
  }

  void _showCreateNoteModal() async {
    final created = await showCreateNoteModal(context, widget.subject.id);

    if (created && mounted) {
      Provider.of<CachedCollection<SubjectNote>>(context, listen: false)
          .refresh(force: true);
    }
  }

  void _pushCreateTaskPage() async {
    final created = await pushCreateTaskPage(context, widget.subject.id);

    if (created && mounted) {
      Provider.of<CachedCollection<SubjectEvent>>(context, listen: false)
          .refresh(force: true);
    }
  }

  void _showCreateEventModal() async {
    final created = await showCreateEventModal(context, widget.subject.id);

    if (created && mounted) {
      Provider.of<CachedCollection<SubjectEvent>>(context, listen: false)
          .refresh(force: true);
    }
  }
}
