import 'package:all_in_order/supabase.dart';

class ProjectEvent {
  int id;
  String name;
  String? description;
  ProjectEventType type;
  DateTime start;
  DateTime? end;

  ProjectEvent({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.start,
    this.end,
  });

  static Future<List<ProjectEvent>?> fetchAll() async {
    final data = await supabase.from('project_events').select();
    return data.map((e) => ProjectEvent.fromJson(e)).toList();
  }

  static Future<ProjectEvent?> fetchById(int id) async {
    final data = await supabase.from('project_events').select().eq('id', id);
    return data.isNotEmpty ? ProjectEvent.fromJson(data.first) : null;
  }

  static Future<List<ProjectEvent>?> fetchManyByIds(List<int> ids) async {
    final data =
        await supabase.from('project_events').select().inFilter('id', ids);
    return data.map((e) => ProjectEvent.fromJson(e)).toList();
  }

  static Future<List<ProjectEvent>?> fetchByAgenda(int agendaId) async {
    // Agenda is referenced through a many-to-many relationship
    final data = await supabase
        .from('project_events')
        .select('*, agenda:agendas()')
        .eq('agenda.id', agendaId);
    return data.map((e) => ProjectEvent.fromJson(e)).toList();
  }

  static Future<List<ProjectEvent>?> fetchByAgendas(List<int> agendaIds) async {
    // Agenda is referenced through a many-to-many relationship
    final data = await supabase
        .from('project_events')
        .select('*, agenda:agendas()')
        .inFilter('agenda.id', agendaIds);
    return data.map((e) => ProjectEvent.fromJson(e)).toList();
  }

  factory ProjectEvent.fromJson(Map<String, dynamic> json) {
    return ProjectEvent(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: eventTypeFromName(json['type']),
      start: DateTime.parse(json['starts_at']),
      end: json['ends_at'] != null ? DateTime.parse(json['ends_at']) : null,
    );
  }
}

enum ProjectEventType {
  task,
  event,
  reminder,
  personalBirthday,
  personalOther,
  other,
}

extension ProjectEventTypeExtension on ProjectEventType {
  String get name {
    switch (this) {
      case ProjectEventType.task:
        return 'Task';
      case ProjectEventType.event:
        return 'Event';
      case ProjectEventType.reminder:
        return 'Reminder';
      case ProjectEventType.personalBirthday:
        return 'Personal Birthday';
      case ProjectEventType.personalOther:
        return 'Personal Other';
      case ProjectEventType.other:
        return 'Other';
    }
  }
}

ProjectEventType eventTypeFromName(String name) {
  switch (name) {
    case 'Task':
      return ProjectEventType.task;
    case 'Event':
      return ProjectEventType.event;
    case 'Reminder':
      return ProjectEventType.reminder;
    case 'Personal Birthday':
      return ProjectEventType.personalBirthday;
    case 'Personal Other':
      return ProjectEventType.personalOther;
    default:
      return ProjectEventType.other;
  }
}
