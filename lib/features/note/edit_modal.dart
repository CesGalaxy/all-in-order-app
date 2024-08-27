import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';

import '../../db/models/subject_note.dart';

Future showNoteEditModal(BuildContext context, SubjectNote note) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => NoteEditor(note: note),
  );
}

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, required this.note});

  final SubjectNote note;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.note.title);
  late final TextEditingController _contentController =
      TextEditingController(text: widget.note.content);
  late final TextEditingController _tagsController =
      TextEditingController(text: widget.note.tags?.join(", "));

  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: ListView(
        children: [
          AppBar(
            title: const Text("Edit note"),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: saving
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.save),
                onPressed: saving ? null : _save,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {},
              ),
            ],
          ),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Title"),
            // onChanged: (value) => widget.note.title = value,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: "Content"),
            // onChanged: (value) => widget.note.content = value,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tagsController,
            decoration: const InputDecoration(labelText: "Tags"),
            // onChanged: (value) => note.tags = value.split(", "),
          ),
        ],
      ),
    );
  }

  void _save() {
    final title = _titleController.text;
    final content = _contentController.text;
    final tags = _tagsController.text.split(", ");

    setState(() {
      saving = true;
    });

    supabase
        .from("project_notes")
        .update({
          "title": title,
          "content": content,
          "tags": tags,
        })
        .eq("id", widget.note.id)
        .then((_) => mounted ? Navigator.of(context).pop() : null)
        .catchError((error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
              ),
            );
          }
        });
  }
}
