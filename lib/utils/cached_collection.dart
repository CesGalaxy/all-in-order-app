import 'package:all_in_order/utils/dynamic_collection.dart';

class CachedCollection<T> extends DynamicCollection<T> {
  /// The minimum time between fetches (can be overridden by [force])
  final Duration cacheDuration;

  /// When the data was last fetched
  DateTime? _lastFetch;

  /// The error that occurred while the latest fetch
  (Object, StackTrace)? _error;

  /// The function that fetches the data
  final Future<List<T>?> Function() fetch;

  /// The current fetch request (if any)
  Future<List<T>?>? _currentFetch;

  // TODO: Fetch on construction?
  CachedCollection({
    required this.fetch,
    required this.cacheDuration,
  });

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

  /// Whether there is any data is available to be used
  bool get dataAvailable => status == CachedDataStatus.done;

  /// Whether the last fetch returned no data
  bool _lastFetchWasNull = false;

  /// The status of the cached data
  CachedDataStatus get status {
    if (error != null) {
      return CachedDataStatus.error;
    } else if (_lastFetch == null) {
      return CachedDataStatus.initializing;
    } else if (_lastFetchWasNull) {
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
        // Start fetching the data
        _currentFetch = fetch();

        // Wait for the request to finish
        final newItems = await _currentFetch;

        // Update the items/error if requested
        if (update) {
          // Check if the fetch returned any data
          if (newItems == null) {
            _lastFetchWasNull = true;
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
        // In case the fetch fails
        _error = (e, s);
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

  /// No data (null) was returned from the fetch
  none,

  /// An error occurred while fetching the data
  error,
}
