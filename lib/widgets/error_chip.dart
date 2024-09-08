import 'package:all_in_order/generated/l10n.dart';
import 'package:flutter/material.dart';

class ErrorChip extends StatelessWidget {
  const ErrorChip({
    super.key,
    this.message,
    this.details,
    required this.action,
  });

  final String? message;
  final String? details;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.error, color: Colors.white),
      label: Text(
        message ?? S.of(context).anErrorOccurred,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      onPressed: () {
        action();

        if (details != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(details!),
            ),
          );
        }
      },
    );
  }
}
