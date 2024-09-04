import 'package:flutter/material.dart';

import '../../../db/models/topic.dart';

class TopicHome extends StatefulWidget {
  const TopicHome({super.key, required this.topic});

  final Topic topic;

  @override
  State<TopicHome> createState() => _TopicHomeState();
}

class _TopicHomeState extends State<TopicHome> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              Text(widget.topic.title, style: Theme.of(context).textTheme.headlineLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.bar_chart)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.chat)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(widget.topic.description, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}