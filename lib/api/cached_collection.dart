import 'package:all_in_order/api/dynamic_collection.dart';

class CachedCollection<T> extends DynamicCollection<T> {
  final Duration cacheDuration;
  DateTime? _lastFetch;

  Object? _error;

  final Future<List<T>?> Function() _fetch;

  // TODO: Fetch on construction?
  CachedCollection({
    required Future<List<T>?> Function() fetch,
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
  Object? get error => _error;

  bool _lastFetchEmpty = false;

  /// The status of the cached data
  CachedDataStatus get status {
    if (error != null) {
      return CachedDataStatus.error;
    } else if (_lastFetch == null) {
      return CachedDataStatus.initializing;
    } else if (_lastFetchEmpty) {
      return CachedDataStatus.none;
    } else {
      return CachedDataStatus.done;
    }
  }

  /// Refresh the data if it's older than [cacheDuration],
  /// if [force] is true, or if it's the first fetch.
  /// Then, if [update] is true, update the items and notify listeners.
  ///
  /// Returns the new items if they were fetched, otherwise null.
  Future<List<T>?> refresh({bool force = false, bool update = true}) async {
    // Check if the data should be refreshed
    if (force ||
        _lastFetch == null ||
        DateTime.now().difference(_lastFetch!) > cacheDuration) {
      try {
        // Fetch new data
        final newItems = await _fetch();

        if (update) {
          // Check if the fetch returned any data
          if (newItems == null) {
            _lastFetchEmpty = true;
            return null;
          }

          // Update the items (and notify listeners)
          setItems(newItems);

          // Remove any previous errors
          _error = null;

          // Update the last fetch time
          _lastFetch = DateTime.now();

          return newItems;
        }
      } catch (e, s) {
        print(s);
        // In case the fetch fails
        _error = e;
      }
    }

    return null;
  }
}

/// The status of the cached data
enum CachedDataStatus {
  /// The data is ready to be used
  done,

  /// The data is being fetched for the first time
  initializing,

  /// No data was returned from the fetch
  none,

  /// An error occurred while fetching the data
  error,
}
