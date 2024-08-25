import 'package:all_in_order/api/dynamic_collection.dart';

class CachedCollection<T> extends DynamicCollection<T> {
  final Duration cacheDuration;
  DateTime? _lastFetch;

  Error? _error;

  final Future<List<T>> Function() _fetch;

  CachedCollection({
    required Future<List<T>> Function() fetch,
    required this.cacheDuration,
  }) : _fetch = fetch;

  /// Get all the cached items and refresh them (in background) if necessary
  @override
  List<T> get items {
    assert(_lastFetch != null, 'You must call fetch() before accessing items');
    refresh();
    return super.items;
  }

  /// The [items] if they are available
  List<T>? get maybeItems => _lastFetch == null ? null : items;

  /// The error that occurred while fetching the data
  Error? get error => _error;

  /// The status of the cached data
  CachedDataStatus get status {
    if (error != null) {
      return CachedDataStatus.error;
    } else if (_lastFetch == null) {
      return CachedDataStatus.initializing;
    } else {
      return CachedDataStatus.done;
    }
  }

  /// Fetch the data and return it
  Future<List<T>> fetch({ bool force = false, bool update = true }) async {
    await refresh(force: force, update: update);
    return items;
  }

  /// Refresh the data if it's older than [cacheDuration], if [force] is true, or if it's the first fetch
  Future<void> refresh({ bool force = false, bool update = true }) async {
    if (force || _lastFetch == null || DateTime.now().difference(_lastFetch!) > cacheDuration) {
      try {
        final newItems = await _fetch();

        if (update) {
          setItems(newItems);
          _lastFetch = DateTime.now();
        }
      } catch (e) {
        _error = e as Error;
      }
    }
  }
}

/// The status of the cached data
enum CachedDataStatus {
  /// The data is ready to be used
  done,

  /// The data is being fetched for the first time
  initializing,

  /// An error occurred while fetching the data
  error,
}
