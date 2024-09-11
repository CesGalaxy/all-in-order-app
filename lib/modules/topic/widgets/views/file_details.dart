import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FileDetails extends StatelessWidget {
  const FileDetails({
    super.key,
    required this.file,
    required this.onEdit,
    required this.onDelete,
  });

  final FileObject file;

  final Function() onEdit;

  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(file.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text('File Name'),
            subtitle: Text(file.name),
            onTap: () => Clipboard.setData(ClipboardData(text: file.name))
                .whenComplete(() {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('File name copied to clipboard')),
                );
              }
            }),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Date Created'),
            subtitle: Text(file.createdAt.toString()),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Created By'),
            subtitle: Text(file.owner ?? "Unknown"),
          ),
        ],
      ),
    );
  }
}
