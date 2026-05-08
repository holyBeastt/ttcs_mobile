import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService(this._secureStorage, this._sharedPreferences);

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  static const String _keyUsername = 'RESERVED_USERNAME';
  static const String _keyPassword = 'RESERVED_PASSWORD';
  static const String _keyRememberMe = 'REMEMBER_ME_FLAG';
  static const String _keyAccessToken = 'ACCESS_TOKEN';
  static const String _keyRefreshToken = 'REFRESH_TOKEN';

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

  Future<void> saveTokens({String? accessToken, String? refreshToken}) async {
    if (accessToken != null) {
      await _secureStorage.write(key: _keyAccessToken, value: accessToken);
    }
    if (refreshToken != null) {
      await _secureStorage.write(key: _keyRefreshToken, value: refreshToken);
    }
  }

  Future<String?> getAccessToken() => _secureStorage.read(key: _keyAccessToken);
  Future<String?> getRefreshToken() => _secureStorage.read(key: _keyRefreshToken);

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyRefreshToken);
  }
}
