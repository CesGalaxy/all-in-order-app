import 'package:all_in_order/db/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubjectSettingsPage extends StatefulWidget {
  const SubjectSettingsPage({super.key, required this.subject});

  final Subject subject;

  @override
  State<SubjectSettingsPage> createState() => _SubjectSettingsPageState();
}

class _SubjectSettingsPageState extends State<SubjectSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'General', icon: Icon(Icons.settings)),
                Tab(text: 'Members', icon: Icon(Icons.people)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: [
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(widget.subject.name),
                  ),
                  ListTile(
                    title: const Text('Description'),
                    subtitle:
                        Text(widget.subject.description ?? "[No description]"),
                  ),
                  // Advanced section
                  Card.filled(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Created at'),
                          subtitle: Text(DateFormat.yMMMd()
                              .format(widget.subject.createdAt)),
                        ),
                        const Divider(),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete subject'),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                ],
              ),
              ListView(
                children: const [
                  ListTile(
                    title: Text('Members'),
                    subtitle: Text("???"),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
