import 'package:all_in_order/supabase.dart';

class TopicTest {
  final int id;
  final int topicId;
  final String name;
  final String? description;
  final DateTime createdAt;

  TopicTest({
    required this.id,
    required this.topicId,
    required this.name,
    this.description,
    required this.createdAt,
  });

  static Future<TopicTest?> fetchById(int id) async {
    final data = await supabase
        .from('topic_tests')
        .select()
        .eq('id', id)
        .limit(1)
        .maybeSingle();

    return data != null ? TopicTest.fromJson(data) : null;
  }

  static Future<List<TopicTest>?> fetchByTopic(int topicId) async {
    final data =
        await supabase.from('topic_tests').select().eq('topic_id', topicId);

    return data.map(TopicTest.fromJson).toList();
  }

  factory TopicTest.fromJson(Map<String, dynamic> map) {
    return TopicTest(
      id: map['id'],
      topicId: map['topic_id'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
