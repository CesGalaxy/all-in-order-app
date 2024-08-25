import 'package:flutter/material.dart';

import '../../db/models/project.dart';
import 'navigation.dart';

class ProjectProviders extends StatefulWidget {
  const ProjectProviders({super.key, required this.project});

  final Project project;

  @override
  State<ProjectProviders> createState() => _ProjectProvidersState();
}

class _ProjectProvidersState extends State<ProjectProviders> {
  // TODO: Wait for fetching
  //DynamicCollection<ProjectNote> _projectNotes = DynamicCollection<ProjectNote>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProjectNavigation(project: widget.project);
  }
}