abstract class KeyValueStorage {
  Future<void> setKeyValue<T>(String key, T value);
  Future<T?> getKeyValue<T>(String key);
  Future<bool> removeKeyValue(String key);
}