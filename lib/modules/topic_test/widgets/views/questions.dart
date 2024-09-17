import 'package:all_in_order/db/models/topic_test.dart';
import 'package:all_in_order/modules/topic_test/questions/question.dart';
import 'package:flutter/material.dart';

class TestQuestions extends StatelessWidget {
  const TestQuestions({super.key, required this.test});

  final TopicTestWithQuestions test;

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: test.questions.length,
        itemBuilder: (context, index) {
          final question = test.questions[index];

          return ListTile(
            title: Text(question.data.title),
            subtitle: question.data.description != null
                ? Text(question.data.description!)
                : null,
            leading: Icon(question.data.type.icon),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => question.data.preview(context),
              );
            },
          );
        },
      );
}
