import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';

class TopicCreationPage extends StatefulWidget {
  const TopicCreationPage({super.key, required this.subjectId});

  final int subjectId;

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
                decoration: const InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter a description for the topic',
                    border: OutlineInputBorder()),
                maxLines: 5,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submitTopicCreation,
                child: const Text('Create Topic'),
              ),
            ],
          )),
    );
  }

  Future _submitTopicCreation() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    // Create the topic
    try {
      await supabase.from('topics').insert({
        'subject_id': widget.subjectId,
        'title': title,
        'description': description,
      });

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }
}
