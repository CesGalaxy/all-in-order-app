import 'package:all_in_order/modules/auth/services/auth_service.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future showCreateNoteModal(BuildContext context, int subjectId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => CreateNoteModal(subjectId: subjectId),
  );
}

class CreateNoteModal extends StatefulWidget {
  const CreateNoteModal({super.key, required this.subjectId});

  final int subjectId;

  @override
  State<CreateNoteModal> createState() => _CreateNoteModalState();
}

class _CreateNoteModalState extends State<CreateNoteModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5 +
          MediaQuery.of(context).viewInsets.bottom,
      child: Scaffold(
        extendBody: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppBar(
                title: const Text('New Note'),
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                actions: [
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const Text('Saving...')
                        : const Text("Create"),
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
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter a title'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          labelText: 'Content',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter some content'
                            : null,
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
        ),
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
