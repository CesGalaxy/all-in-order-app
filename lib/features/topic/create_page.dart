import 'package:flutter/material.dart';

class TopicCreationPage extends StatefulWidget {
  const TopicCreationPage({super.key});

  @override
  State<TopicCreationPage> createState() => _TopicCreationPageState();
}

class _TopicCreationPageState extends State<TopicCreationPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Topic'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter a description for the topic',
                    border: OutlineInputBorder()
                ),
                maxLines: 5,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Save the topic
                  Navigator.of(context).pop();
                },
                child: const Text('Create Topic'),
              ),
            ],
          )),
    );
  }
}
