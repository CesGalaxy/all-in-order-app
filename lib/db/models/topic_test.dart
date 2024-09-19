import 'package:all_in_order/db/models/topic_test_question.dart';
import 'package:all_in_order/supabase.dart';

class TopicTest {
  final int id;
  final int topicId;
  final String name;
  final String? description;
  final DateTime createdAt;

  const TopicTest({
    required this.id,
    required this.topicId,
    required this.name,
    this.description,
    required this.createdAt,
  });

  static Future<List<TopicTest>?> fetchByTopic(int topicId) => supabase
      .from('topic_tests')
      .select()
      .eq('topic_id', topicId)
      .then((raw) => raw.map(TopicTest.fromJson).toList());

  factory TopicTest.fromJson(Map<String, dynamic> map) => TopicTest(
        id: map['id'],
        topicId: map['topic_id'],
        name: map['name'],
        description: map['description'],
        createdAt: DateTime.parse(map['created_at']),
      );
}

class TopicTestWithQuestions extends TopicTest {
  final List<TopicTestQuestion> questions;

  const TopicTestWithQuestions({
    required super.id,
    required super.topicId,
    required super.name,
    super.description,
    required super.createdAt,
    required this.questions,
  });

  static Future<List<TopicTestWithQuestions>?> fetchByTopic(int topicId) =>
      supabase
          .from('topic_tests')
          .select("*, questions:topic_test_questions(*)")
          .eq('topic_id', topicId)
          .then((raw) => raw.map(TopicTestWithQuestions.fromJson).toList());

  factory TopicTestWithQuestions.fromJson(Map<String, dynamic> map) =>
      TopicTestWithQuestions(
        id: map['id'],
        topicId: map['topic_id'],
        name: map['name'],
        description: map['description'],
        createdAt: DateTime.parse(map['created_at']),
        questions: map['questions']
            .map<TopicTestQuestion>(
                (e) => TopicTestQuestion.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
