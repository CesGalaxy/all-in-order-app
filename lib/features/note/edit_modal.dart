import 'package:flutter/material.dart';

import '../../db/models/project_note.dart';

Future showNoteEditModal(BuildContext context, ProjectNote note) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => NoteEditor(note: note),
  );
}

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, required this.note});

  final ProjectNote note;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late final TextEditingController _titleController = TextEditingController(text: widget.note.title);
  late final TextEditingController _contentController = TextEditingController(text: widget.note.content);
  late final TextEditingController _tagsController = TextEditingController(text: widget.note.tags?.join(", "));

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
                icon: const Icon(Icons.save),
                onPressed: () {},
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
}
