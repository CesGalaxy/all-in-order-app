import 'package:all_in_order/modules/topic_test/questions/fill_the_gap.dart';
import 'package:flutter/material.dart';

import 'choice.dart';

abstract class TestQuestionData {
  final String title;
  final String? description;

  final TestQuestionType type;

  const TestQuestionData({
    required this.title,
    required this.description,
    required this.type,
  });

  factory TestQuestionData.fromJson(Map<String, dynamic> json) {
    switch (TestQuestionTypeExtension.fromString(json['type'])) {
      case TestQuestionType.choice:
        return ChoiceQuestionData.fromJson(json);
      case TestQuestionType.fillTheGap:
        return FillTheGapQuestionData.fromJson(json);
    }
  }

  Widget preview(BuildContext context);
}

enum TestQuestionType {
  choice,
  fillTheGap,
}

extension TestQuestionTypeExtension on TestQuestionType {
  String get value {
    switch (this) {
      case TestQuestionType.choice:
        return 'choice';
      case TestQuestionType.fillTheGap:
        return 'fill_the_gap';
    }
  }

  static TestQuestionType fromString(String value) {
    switch (value) {
      case 'choice':
        return TestQuestionType.choice;
      case 'fill_the_gap':
        return TestQuestionType.fillTheGap;
      default:
        throw Exception('Unknown question type: $value');
    }
  }

  IconData get icon {
    switch (this) {
      case TestQuestionType.choice:
        return Icons.rule;
      case TestQuestionType.fillTheGap:
        return Icons.edit_note;
    }
  }
}
