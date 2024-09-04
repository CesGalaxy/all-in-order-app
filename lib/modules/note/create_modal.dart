import 'package:all_in_order/modules/auth/services/auth_service.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future showCreateNoteModal(BuildContext context, int subjectId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => CreateNotePage(subjectId: subjectId),
  );
}

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key, required this.subjectId});

  final int subjectId;

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5 +
          MediaQuery.of(context).viewInsets.bottom,
      child: Column(
        children: [
          AppBar(
            title: const Text('New Note'),
            backgroundColor: Colors.transparent,
            actions: [
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const Text('Saving...') : const Text("Create"),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: SizedBox(
              height: (MediaQuery.of(context).size.height * 0.5) - 88,
              child: ListView(
                padding: const EdgeInsets.only(top: 16),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a content';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                      labelText: 'Tags',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final content = _contentController.text;
      final tags =
          _tagsController.text.split(', ').map((e) => e.trim()).toList();

      // Save the note
      setState(() {
        _saving = true;
      });

      final profileId =
          Provider.of<AuthService>(context, listen: false).profile!.id;

      supabase.from('subject_notes').insert({
        'subject_id': widget.subjectId,
        'author_id': profileId,
        'title': title,
        'content': content,
        'tags': tags,
      }).then((value) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
