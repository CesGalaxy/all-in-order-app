import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/widgets/empty_collection_screen.dart';
import 'package:all_in_order/widgets/error_chip.dart';
import 'package:flutter/material.dart';

class CacheHandler<T> extends StatelessWidget {
  const CacheHandler({
    super.key,
    required this.collection,
    required this.builder,
    this.child,
    this.errorMessage,
    this.errorDetails,
    required this.errorAction,
    this.emptyTitle,
    required this.emptyActionLabel,
    required this.emptyAction,
  });

  final CachedCollection<T> collection;

  final Widget Function(
    BuildContext context,
    List<T> data,
    Widget? child,
  ) builder;

  final Widget? child;

  final String? Function(Object error)? errorMessage;
  final String? Function(Object error)? errorDetails;
  final Function(Object error) errorAction;

  final String? emptyTitle;
  final String emptyActionLabel;
  final Function() emptyAction;

  @override
  Widget build(BuildContext context) {
    collection.refresh();

    switch (collection.status) {
      case CachedDataStatus.done:
        return collection.items.isEmpty
            ? EmptyCollectionScreen(
                title: emptyTitle,
                actionLabel: emptyActionLabel,
                action: emptyAction,
              )
            : builder(context, collection.items, child);
      case CachedDataStatus.none:
      case CachedDataStatus.error:
        return Center(
          child: ErrorChip(
            message: errorMessage?.call(collection.error!),
            action: () {
              print(collection.error!.toString());

              errorAction(collection.error!);
            },
            details: errorDetails?.call(collection.error!),
          ),
        );
      case CachedDataStatus.initializing:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
