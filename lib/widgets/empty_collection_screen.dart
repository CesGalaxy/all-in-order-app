import 'package:flutter/material.dart';

class EmptyCollectionScreen extends StatelessWidget {
  const EmptyCollectionScreen({
    super.key,
    this.title,
    required this.actionLabel,
    required this.action,
  });

  final String? title;
  final String actionLabel;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: title != null
          ? Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title!),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: action,
                      child: Text(actionLabel),
                    ),
                  ],
                ),
              ),
            )
          : FilledButton(
              onPressed: action,
              child: Text(actionLabel),
            ),
    );
  }
}
