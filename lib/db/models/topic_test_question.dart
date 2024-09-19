import 'package:all_in_order/modules/topic_test/questions/question.dart';
import 'package:all_in_order/utils/db.dart';

class TopicTestQuestion<T extends TestQuestionData> {
  final int id;
  final int testId;
  final int position;
  final T data;
  final DateTime? updatedAt;
  final DateTime createdAt;

  const TopicTestQuestion({
    required this.id,
    required this.testId,
    required this.position,
    required this.data,
    required this.updatedAt,
    required this.createdAt,
  });

  factory TopicTestQuestion.fromJson(Map<String, dynamic> json) =>
      TopicTestQuestion(
        id: json['id'],
        testId: json['test_id'],
        position: json['position'],
        data: TestQuestionData.fromJson(json['data']) as T,
        updatedAt: tryToParse(json['updated_at'] as String, DateTime.parse),
        createdAt: DateTime.parse(json['created_at']),
      );
}
