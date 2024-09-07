import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocViewer extends StatelessWidget {
  final FileObject doc;

  const DocViewer({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doc.name),
      ),
      body: Markdown(data: "hello"),
    );
  }
}