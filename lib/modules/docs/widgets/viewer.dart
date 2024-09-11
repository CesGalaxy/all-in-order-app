import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DocViewer extends StatefulWidget {
  const DocViewer({
    super.key,
    required this.name,
    required this.downloadDoc,
  });

  final String name;
  final Future<Uint8List> Function() downloadDoc;

  @override
  State<DocViewer> createState() => DocViewerState();
}

class DocViewerState extends State<DocViewer> {
  late Future<Uint8List> _downloadRequest = widget.downloadDoc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          // More
          PopupMenuButton<_DocViewerAction>(
            onSelected: (value) {
              switch (value) {
                case _DocViewerAction.refresh:
                  setState(() {
                    _downloadRequest = widget.downloadDoc();
                  });
                  break;
                case _DocViewerAction.edit:
                  // Show an alert dialog: This feature is not available yet
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Feature not available'),
                      content: const Text(
                          'For now, you can use the web version for editing documents. Mind maps can be edited with the XMind app.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                case _DocViewerAction.delete:
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _DocViewerAction.refresh,
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Refresh'),
                ),
              ),
              const PopupMenuItem(
                value: _DocViewerAction.edit,
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
              const PopupMenuItem(
                value: _DocViewerAction.delete,
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: _downloadRequest,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Markdown(data: String.fromCharCodes(snapshot.data!));
        },
      ),
    );
  }
}

enum _DocViewerAction { refresh, edit, delete }
