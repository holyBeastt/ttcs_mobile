import 'package:flutter/foundation.dart';

import 'package:mobile/src/models/session_user.dart';
import 'package:mobile/src/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._authService);

  final AuthService _authService;

  bool _initialized = false;
  bool _isLoading = false;
  String? _error;
  SessionUser? _currentUser;

  bool get initialized => _initialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  SessionUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> bootstrap() async {
    if (_initialized) return;
    _isLoading = true;
    notifyListeners();

    _initialized = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.login(
        username: username,
        password: password,
      );
      return true;
    } catch (error) {
      _error = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _authService.logout();
    _currentUser = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
