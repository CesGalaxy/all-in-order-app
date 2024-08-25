import 'package:flutter/material.dart';

class DynamicCollection<T> extends ChangeNotifier {
  List<T> _items = [];

  List<T> get items => _items;

  void setItems(List<T> items) {
    _items = items;
    notifyListeners();
  }

  void addItem(T item) {
    _items.add(item);
    notifyListeners();
  }

  void updateState(VoidCallback? action) {
    action?.call();
    notifyListeners();
  }
}