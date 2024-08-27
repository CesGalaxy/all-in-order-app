import 'package:all_in_order/db/models/project_event.dart';

import '../../supabase.dart';

class Agenda {
  int id;
  String slug;
  String name;
  String? resume;
  String? description;

  List<ProjectEvent> events;

  Agenda({
    required this.id,
    required this.slug,
    required this.name,
    required this.resume,
    required this.description,
    required this.events,
  });

  static Future<List<Agenda>?> fetchByProject(int projectId) async {
    final data = await supabase
        .from('agendas')
        .select('*, project:projects(), events:project_events(*)')
        .eq('project.id', projectId);
    return data.map(Agenda.fromJson).toList();
  }

  factory Agenda.fromJson(Map<String, dynamic> json) {
    // Listen to me, bitch. DON'T FUCKING TOUCH THIS!
    // I swear I'll make you swallow the screen if this stops working.
    final List<dynamic> rawEvents = json['events'];
    final List<Map<String, dynamic>> abc = rawEvents.map<Map<String, dynamic>>((a) =>Map<String, dynamic>.from(a as Map)).toList();
    final events = abc.map<ProjectEvent>(ProjectEvent.fromJson).toList();

    return Agenda(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      resume: json['resume'],
      description: json['description'],
      events: events
    );
  }
}
