import 'package:flutter/material.dart';

class DynamicMap<K, V> extends ChangeNotifier {
  Map<K, V> _data = {};

  Map<K, V> get data => _data;

  List<K> get keys => _data.keys.toList();

  List<V> get values => _data.values.toList();

  void setData(Map<K, V> data) {
    _data = data;
    notifyListeners();
  }

  void updateState(VoidCallback? action) {
    action?.call();
    notifyListeners();
  }

  void set(K key, V value) {
    _data[key] = value;
    notifyListeners();
  }

  void setAll(Map<K, V> data) {
    _data.addAll(data);
    notifyListeners();
  }

  V? get(K key) {
    return _data[key];
  }

  void remove(K key) {
    _data.remove(key);
    notifyListeners();
  }

  void clear() {
    _data.clear();
    notifyListeners();
  }

  bool contains(K key) {
    return _data.containsKey(key);
  }
}