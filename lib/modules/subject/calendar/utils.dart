import 'package:all_in_order/db/models/subject_event.dart';

List<SubjectEvent> getEventsForDay(DateTime day, List<SubjectEvent> events) {
  return events.where((event) => event.isInDay(day)).toList();
}
