import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gestor_cafeteria/core/failure.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client? _client;
  final Uri? baseUrl;
  final Duration timeout;

  ApiClient({
    http.Client? client,
    String? baseUrl,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client(),
       baseUrl = Uri.parse(
         baseUrl ??
             (const String.fromEnvironment('API_URL').isNotEmpty
                 ? const String.fromEnvironment('API_URL')
                 : (kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000')),
       );

  Future<dynamic> get(String path) => _send('GET', path);
  Future<dynamic> post(String path, Object body) => _send('POST', path, body);
  Future<dynamic> patch(String path, Object body) => _send('PATCH', path, body);
  Future<dynamic> update(String path, Object body) =>
      _send('UPDATE', path, body);
  Future<void> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(String method, String path, [Object? body]) async {
    final request = http.Request(method, baseUrl!.resolve(path))
      ..headers['Accept'] = 'application/json';

    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    final http.Response response;
    try {
      response = await _client!
          .send(request)
          .then(http.Response.fromStream)
          .timeout(timeout);
    } on http.ClientException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const NetworkFailure();
    }

    final json = _tryDecode(response);
    final code = response.statusCode;
    if (code >= 200 && code <= 300) return json;

    switch (code) {
      case 404:
        throw NotFoundFailure(_extractDetailMessage(json, 'Recurso no encontrado'));
      case 409:
        throw ConflictFailure(_extractDetailMessage(json, 'Conflicto en la solicitud'));
      case 422:
        throw ValidationFailure(_extractValidationFields(json));
      case >= 500 && <= 599:
        throw ServerFailure(code);
      default:
        throw UnexpectedFailure(
          code,
          _extractDetailMessage(json, 'Error inesperado'),
        );
    }
  }

  String _extractDetailMessage(dynamic json, String fallback) {
    if (json is Map && json['detail'] is String) {
      return json['detail'] as String;
    }
    return fallback;
  }

  Map<String, String> _extractValidationFields(dynamic json) {
    final fields = <String, String>{};
    if (json is Map && json['detail'] is List) {
      for (final item in json['detail'] as List) {
        if (item is Map) {
          final loc = item['loc'];
          final msg = item['msg'];
          if (loc is List && loc.length > 1 && msg != null) {
            fields[loc[1].toString()] = msg.toString();
          }
        }
      }
    }
    return fields;
  }

  dynamic _tryDecode(http.Response response) {
    if (response.bodyBytes.isEmpty) return null;

    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      return null;
    }
  }
}
