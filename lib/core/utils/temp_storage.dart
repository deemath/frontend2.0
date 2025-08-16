class TempStorage {
  static final Map<String, dynamic> _storage = {};

  static void store(String key, dynamic value) {
    _storage[key] = value;
  }

  static T? get<T>(String key) {
    return _storage[key] as T?;
  }

  static void remove(String key) {
    _storage.remove(key);
  }

  static void clear() {
    _storage.clear();
  }
}
