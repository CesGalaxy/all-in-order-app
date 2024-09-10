import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';

Future<bool> showSubjectCreationModal(BuildContext context, int courseId) =>
    showModalBottomSheet(
      context: context,
      builder: (context) => CreateSubjectModal(courseId: courseId),
    ).then((created) => created ?? false);

class CreateSubjectModal extends StatefulWidget {
  const CreateSubjectModal({super.key, required this.courseId});

  final int courseId;

  @override
  State<CreateSubjectModal> createState() => _CreateSubjectModalState();
}

class _CreateSubjectModalState extends State<CreateSubjectModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Color _color = Colors.blue;

  static const subjectDefaultColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightGreen,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: const Text("Create a new subject"),
              centerTitle: true,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
              validator: (name) => (name == null || name.length < 3)
                  ? "Provide a name for the subject"
                  : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 16),
            Wrap(
              children: [
                ...subjectDefaultColors.map((color) => GestureDetector(
                      onTap: () => setState(() => _color = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color,
                          border: _color == color
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    )),
                // Custom
                GestureDetector(
                  onTap: () async {
                    final color = await showDialog<Color>(
                      context: context,
                      builder: (context) => _customColorPicker(context),
                    );

                    if (color != null) {
                      setState(() => _color = color);
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: subjectDefaultColors.contains(_color)
                          ? Theme.of(context).canvasColor
                          : _color,
                      border: subjectDefaultColors.contains(_color)
                          ? null
                          : Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _submitSubjectCreation,
              icon: const Icon(Icons.create),
              label: const Text("Create subject"),
              style: ElevatedButton.styleFrom(backgroundColor: _color),
            ),
          ],
        ),
      );

  AlertDialog _customColorPicker(BuildContext context) {
    return AlertDialog(
      title: const Text("Pick a color"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text("R:"),
              Expanded(
                child: Slider(
                  value: _color.red.toDouble(),
                  min: 0,
                  max: 255,
                  onChanged: (value) =>
                      setState(() => _color = _color.withRed(value.toInt())),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("G:"),
              Expanded(
                child: Slider(
                  value: _color.green.toDouble(),
                  min: 0,
                  max: 255,
                  onChanged: (value) =>
                      setState(() => _color = _color.withGreen(value.toInt())),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("B:"),
              Expanded(
                child: Slider(
                  value: _color.blue.toDouble(),
                  min: 0,
                  max: 255,
                  onChanged: (value) =>
                      setState(() => _color = _color.withBlue(value.toInt())),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          width: MediaQuery.of(context).size.width - 208,
          height: 32,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _color),
          child: const Text("Ok"),
        ),
      ],
    );
  }

  void _submitSubjectCreation() async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(true);
    }

    try {
      await supabase.from("subjects").insert({
        "course_id": widget.courseId,
        "name": _nameController.text,
        "description": _descriptionController.text,
        "color": _color.value,
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text("An error occurred: $e"),
          ),
        );
      }
    }
  }
}
