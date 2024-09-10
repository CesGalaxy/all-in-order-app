import 'dart:typed_data';

import 'package:all_in_order/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Uint8List> getTopicDocumentByName(int topicId, String name) {
  return supabase.storage.from("topic_documents").download("$topicId/$name.md");
}

Future<List<FileObject>> getAllTopicsDocuments() {
  return supabase.storage.from("topic_documents").list();
}

Future<List<FileObject>> getTopicDocuments(int topicId) async {
  print("getTopicDocuments started");
  return supabase.storage
      .from("topic_documents")
      .list(path: "$topicId/")
      .whenComplete(() {
    print("getTopicDocuments completed");
  });
}
