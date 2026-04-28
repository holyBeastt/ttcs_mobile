import '../models/session_user.dart';
import 'api_client.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<SessionUser> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/login',
      body: {
        'username': username,
        'password': password,
      },
    );

    return SessionUser.fromJson(response);
  }

  Future<void> logout() async {
    _apiClient.clearSession();
  }
}
