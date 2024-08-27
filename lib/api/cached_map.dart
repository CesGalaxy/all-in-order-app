import 'dynamic_map.dart';

class CachedMap<K, V> extends DynamicMap<K, V> {
  final Duration cacheDuration;
  DateTime? _lastFetch;

  Object? _error;

  final Future<(K, V)> Function(K)? fetchOneRequest;
  final Future<Map<K, V>> Function(List<K>)? fetchSomeRequest;

  CachedMap({
    this.fetchOneRequest,
    this.fetchSomeRequest,
    required this.cacheDuration,
  });

  Future<V?> fetchOne(K key, {bool useCache = true, bool update = true}) async {
    final cached = useCache ? contains(key) : false;

    if (cached) {
      return get(key);
    } else {
      try {
        final (key2, value) = await fetchOneRequest!(key);
        assert(key == key2,
            'The key returned by fetchOne must be the same as the one passed');
        if (update) {
          set(key, value);
        }
        return value;
      } catch (e) {
        _error = e;
        return null;
      }
    }
  }

  Future<Map<K, V>> fetchSome(List<K> keys,
      {bool force = false, bool update = true}) async {
    final cached = !force && keys.every(contains);

    if (cached) {
      return Map.fromEntries(keys.map((key) => MapEntry(key, get(key)!)));
    } else {
      try {
        final newItems = await fetchSomeRequest!(keys);
        assert(keys.every(newItems.containsKey),
            'The keys returned by fetchSome must be the same as the ones passed');
        if (update) {
          setAll(newItems);
        }
        return newItems;
      } catch (e) {
        _error = e;
        return {};
      }
    }
  }

  Future<void> refresh({bool force = false, bool update = true}) async {
    if (force ||
        _lastFetch == null ||
        DateTime.now().difference(_lastFetch!) > cacheDuration) {
      try {
        final newItems = await fetchSome(keys, force: force, update: update);
        if (update) {
          setAll(newItems);
          _lastFetch = DateTime.now();
        }
      } catch (e) {
        _error = e;
      }
    }
  }

  Future<V?> refreshOne(K key, {bool force = false, bool update = true}) async {
    return fetchOne(key,
        useCache: force ||
            _lastFetch == null ||
            DateTime.now().difference(_lastFetch!) > cacheDuration,
        update: update);
  }

  Future<Map<K, V>> refreshSome(List<K> keys,
      {bool force = false, bool update = true}) async {
    return fetchSome(keys,
        force: force ||
            _lastFetch == null ||
            DateTime.now().difference(_lastFetch!) > cacheDuration,
        update: update);
  }
}
