import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mobile/src/config/app_config.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  String? _sessionCookie;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      'GET',
      path,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _request(
      'POST',
      path,
      body: body,
    );
  }

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _request(
      'PATCH',
      path,
      body: body,
    );
  }

  Future<String> getText(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _send(
      'GET',
      path,
      queryParameters: queryParameters,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    }

    throw ApiException(
      response.body.isEmpty ? 'Request failed' : response.body,
      statusCode: response.statusCode,
    );
  }

  void clearSession() {
    _sessionCookie = null;
  }

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final response = await _send(
      method,
      path,
      queryParameters: queryParameters,
      body: body,
    );

    dynamic json;
    try {
      json = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    } on FormatException {
      throw ApiException(
        'Expected JSON response but received a different format',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }

    throw ApiException(
      json['message']?.toString() ?? 'Request failed',
      statusCode: response.statusCode,
    );
  }

  Future<http.Response> _send(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_sessionCookie != null && _sessionCookie!.isNotEmpty) {
      headers['Cookie'] = _sessionCookie!;
    }

    final uri = AppConfig.endpoint(path, queryParameters);
    late http.Response response;

    switch (method) {
      case 'GET':
        response = await _httpClient.get(uri, headers: headers);
        break;
      case 'POST':
        response = await _httpClient.post(
          uri,
          headers: headers,
          body: jsonEncode(body ?? <String, dynamic>{}),
        );
        break;
      case 'PATCH':
        response = await _httpClient.patch(
          uri,
          headers: headers,
          body: jsonEncode(body ?? <String, dynamic>{}),
        );
        break;
      default:
        throw ApiException('Unsupported method: $method');
    }

    final setCookieHeader = response.headers['set-cookie'];
    if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
      _sessionCookie = setCookieHeader.split(';').first;
    }

    return response;
  }
}
