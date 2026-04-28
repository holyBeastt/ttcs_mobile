class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.10.11.218:3000',
  );

  static Uri endpoint(String path, [Map<String, dynamic>? queryParameters]) {
    final sanitizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$apiBaseUrl$sanitizedPath').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value?.toString()),
      ),
    );
  }
}
