import 'package:flutter/material.dart';

/// A wrapper around a list that notifies listeners when its content changes.
class DynamicCollection<T> extends ChangeNotifier {
  List<T> _items = [];

  /// The list of items
  List<T> get items => _items;

  /// Set the list of items (will notify listeners)
  void setItems(List<T> items) {
    _items = items;
    notifyListeners();
  }

  /// Add an item to the list (will notify listeners)
  void addItem(T item) {
    _items.add(item);
    notifyListeners();
  }

  /// Notify listeners after executing [action] (if provided)
  void updateState(VoidCallback? action) {
    action?.call();
    notifyListeners();
  }
}
