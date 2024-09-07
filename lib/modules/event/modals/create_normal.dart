import 'package:flutter/material.dart';

class CreateNormalEventModal extends StatefulWidget {
  const CreateNormalEventModal({super.key});

  @override
  State<CreateNormalEventModal> createState() => _CreateNormalEventModalState();
}

class _CreateNormalEventModalState extends State<CreateNormalEventModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Event'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Time'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
