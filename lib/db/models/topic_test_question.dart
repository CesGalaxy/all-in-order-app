import 'package:all_in_order/modules/topic_test/questions/question.dart';

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

  factory TopicTestQuestion.fromJson(Map<String, dynamic> json) {
    return TopicTestQuestion(
      id: json['id'],
      testId: json['test_id'],
      position: json['position'],
      data: TestQuestionData.fromJson(json['data']) as T,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
