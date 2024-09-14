import 'package:all_in_order/modules/topic_test/questions/question.dart';
import 'package:flutter/material.dart';

class FillTheGapQuestionData extends TestQuestionData {
  final List<Segment> segments;

  FillTheGapQuestionData({
    required super.title,
    required super.description,
    required this.segments,
  }) : super(type: TestQuestionType.fillTheGap);

  factory FillTheGapQuestionData.fromJson(Map<String, dynamic> json) {
    assert(json['type'] == TestQuestionType.fillTheGap.value);

    return FillTheGapQuestionData(
      title: json['title'],
      description: json['description'],
      segments: json['segments'].map<Segment>(Segment.fromJson).toList(),
    );
  }

  @override
  Widget preview(BuildContext context) => ListView(
        padding: const EdgeInsets.all(8),
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(title),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            spacing: 8,
            children:
                segments.map((segment) => segment.preview(context)).toList(),
          ),
        ],
      );
}

abstract class Segment {
  factory Segment.fromJson(dynamic json) {
    if (json is String) return TextSegment(json);

    switch (json['type']) {
      case 'choice':
        return ChoiceGapSegment.fromJson(json);
      case 'text':
        return TextGapSegment.fromJson(json);
      default:
        throw Exception('Unknown segment type: ${json['type']}');
    }
  }

  Widget preview(BuildContext context);
}

class TextSegment implements Segment {
  /// The text of the segment.
  final String text;

  const TextSegment(this.text);

  @override
  Widget preview(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.bodyLarge);
}

abstract class GapSegment<T> implements Segment {
  /// Checks whether a given answer is correct for the gap.
  bool isCorrect(T answer);

  static fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'choice') {
      return ChoiceGapSegment.fromJson(json);
    } else if (json['type'] == 'text') {
      return TextGapSegment.fromJson(json);
    } else {
      throw Exception('Unknown gap segment type: ${json['type']}');
    }
  }
}

class ChoiceGapSegment implements GapSegment<String> {
  /// The correct choices.
  final List<String> correctChoices;

  /// The wrong choices.
  final List<String> wrongChoices;

  ChoiceGapSegment(this.correctChoices, this.wrongChoices);

  /// Generates a shuffled list with all the choices.
  List<String> get choices => [...correctChoices, ...wrongChoices]..shuffle();

  /// Check if the selected answer is correct.
  @override
  bool isCorrect(String answer) => correctChoices.contains(answer);

  factory ChoiceGapSegment.fromJson(Map<String, dynamic> json) {
    final List<List<dynamic>> rawChoices =
        List<List<dynamic>>.from(json['choices']);

    final List<(String, bool)> allChoices = rawChoices
        .map<(String, bool)>((choice) => (choice[0], choice[1]))
        .toList();

    final List<String> correctChoices = allChoices
        .where((choice) => choice.$2)
        .map((choice) => choice.$1)
        .toList();
    final List<String> wrongChoices = allChoices
        .where((choice) => !choice.$2)
        .map((choice) => choice.$1)
        .toList();

    return ChoiceGapSegment(correctChoices, wrongChoices);
  }

  @override
  Widget preview(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).focusColor,
        ),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: [
                ...correctChoices.map((choice) => ChoiceChip(
                      label: Text(choice),
                      selected: true,
                      onSelected: (_) {},
                    )),
                ...wrongChoices.map((choice) => ChoiceChip(
                      label: Text(choice),
                      selected: false,
                      onSelected: (_) {},
                    )),
              ],
            ),
          ],
        ),
      );
}

class TextGapSegment implements GapSegment<String> {
  /// All the posible correct answers.
  final List<String> correctAnswers;

  TextGapSegment(this.correctAnswers);

  /// Check if the selected answer is correct.
  @override
  bool isCorrect(String answer) => correctAnswers.contains(answer);

  factory TextGapSegment.fromJson(Map<String, dynamic> json) {
    return TextGapSegment(List<String>.from(json['answers']));
  }

  @override
  Widget preview(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).focusColor,
        ),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: correctAnswers
                  .map((choice) => ChoiceChip(
                        label: Text(choice),
                        selected: true,
                        onSelected: (_) {},
                        color: WidgetStateProperty.all(
                            Theme.of(context).highlightColor),
                      ))
                  .toList(),
            ),
          ],
        ),
      );
}
