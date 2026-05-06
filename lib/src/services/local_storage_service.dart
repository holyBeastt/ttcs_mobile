import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService(this._secureStorage, this._sharedPreferences);

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  static const String _keyUsername = 'RESERVED_USERNAME';
  static const String _keyPassword = 'RESERVED_PASSWORD';
  static const String _keyRememberMe = 'REMEMBER_ME_FLAG';

  Future<void> saveCredentials(String username, String password) async {
    await _sharedPreferences.setBool(_keyRememberMe, true);
    await _sharedPreferences.setString(_keyUsername, username);
    await _secureStorage.write(key: _keyPassword, value: password);
  }

  Future<Map<String, String>?> getCredentials() async {
    final rememberMe = _sharedPreferences.getBool(_keyRememberMe) ?? false;
    if (!rememberMe) return null;

    final username = _sharedPreferences.getString(_keyUsername);
    final password = await _secureStorage.read(key: _keyPassword);

    if (username != null && password != null && username.isNotEmpty && password.isNotEmpty) {
      return {'username': username, 'password': password};
    }
    return null;
  }

  Future<void> clearCredentials() async {
    await _sharedPreferences.setBool(_keyRememberMe, false);
    await _sharedPreferences.remove(_keyUsername);
    await _secureStorage.delete(key: _keyPassword);
  }
}
