import 'package:shared_preferences/shared_preferences.dart';
import 'i_data_base.dart';

/// Класс хранилище, используем только для типов int, double, String
class MyStorage implements IDataBase {
  final SharedPreferences _prefs;

  const MyStorage(this._prefs);

  @override
  Future<T?> get<T>(String key) async {
    if (_sameTypes<T, int>()) {
      return _prefs.getInt(key) as T?;
    }

    if (_sameTypes<T, double>()) {
      return _prefs.getDouble(key) as T?;
    }

    // В методе get мы получаем либо int, либо double, иначе String
    return _prefs.getString(key) as T?;
  }

  @override
  Future<void> set<T>(String key, T value) async {
    if (_sameTypes<T, int>()) {
      await _prefs.setInt(key, value as int);
      return;
    }

    if (_sameTypes<T, double>()) {
      await _prefs.setDouble(key, value as double);
      return;
    }

    // Если это не int, не double, значит получаем строку
    await _prefs.setString(key, value as String);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Внутренний метод для проверки передаваемого типа
  bool _sameTypes<S, V>() {
    void func<X extends S>() {}
    return func is void Function<X extends V>();
  }
}
