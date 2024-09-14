import 'package:all_in_order/modules/topic_test/questions/question.dart';
import 'package:all_in_order/utils/numerus.dart';
import 'package:flutter/material.dart';

class ChoiceQuestionData extends TestQuestionData {
  /// How the choices should be displayed.
  final ChoiceListType listType;

  /// The correct choices, if there are more than one then it's a multiple choice question.
  final List<String> correctChoices;

  /// The wrong choices.
  final List<String> wrongChoices;

  ChoiceQuestionData({
    required super.title,
    super.description,
    required this.listType,
    required this.correctChoices,
    required this.wrongChoices,
  }) : super(type: TestQuestionType.choice);

  factory ChoiceQuestionData.fromJson(Map<String, dynamic> json) {
    assert(json['type'] == TestQuestionType.choice.value);

    return ChoiceQuestionData(
      title: json['title'],
      description: json['description'],
      listType: ChoiceListTypeExtension.fromString(json['list_type']),
      correctChoices: List<String>.from(json['correct_choices']),
      wrongChoices: List<String>.from(json['wrong_choices']),
    );
  }

  bool get isMultipleChoice => correctChoices.length > 1;

  List<(String?, String)> get choices {
    final List<String> allChoices = [...correctChoices, ...wrongChoices]
      ..shuffle();
    switch (listType) {
      case ChoiceListType.none:
        return allChoices.map((choice) => (null, choice)).toList();
      case ChoiceListType.alphabet:
        return allChoices
            .asMap()
            .entries
            .map((entry) => (String.fromCharCode(97 + entry.key), entry.value))
            .toList();
      case ChoiceListType.number:
        return allChoices
            .asMap()
            .entries
            .map((entry) => ((entry.key + 1).toString(), entry.value))
            .toList();
      case ChoiceListType.roman:
        return allChoices
            .asMap()
            .entries
            .map((entry) => (romanNumeral(entry.key + 1), entry.value))
            .toList();
    }
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
                onPressed: () => Navigator.of(context).pop(),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          ...correctChoices
              .map((choice) => previewChoice(context, true, choice)),
          ...wrongChoices
              .map((choice) => previewChoice(context, false, choice)),
        ],
      );

  Widget previewChoice(BuildContext context, bool correct, String choice) =>
      ListTile(
        title: Text(choice),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            correct ? Icons.check : Icons.close,
            color: correct ? Colors.green : Colors.red,
          ),
        ),
        onTap: () {},
      );
}

/// The type of list to display the choices.
enum ChoiceListType {
  /// An unordered list of choices.
  none,

  /// With the original order. Pattern: a, b, c...
  alphabet,

  /// With the original order. Pattern: 1, 2, 3...
  number,

  /// With the original order. Pattern: i, i, iii...
  roman,
}

extension ChoiceListTypeExtension on ChoiceListType {
  static fromString(String value) {
    switch (value) {
      case 'alphabet':
        return ChoiceListType.alphabet;
      case 'number':
        return ChoiceListType.number;
      case 'roman':
        return ChoiceListType.roman;
      default:
        return ChoiceListType.none;
    }
  }
}
