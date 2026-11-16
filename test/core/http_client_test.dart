import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/core/failure.dart';
import 'package:gestor_cafeteria/core/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('Pruebas unitarias de ApiClient', () {
    // 1. Éxito
    test('GET exitoso devuelve el JSON decodificado', () async {
      final mock = MockClient((request) async {
        return http.Response('[{"id": 1, "drink": "latte"}]', 200,
            headers: {'content-type': 'application/json'});
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      final resultado = await api.get('/orders');

      expect(resultado, isA<List>());
      expect(resultado, equals([{'id': 1, 'drink': 'latte'}]));
    });

    // 2. No encontrado
    test('GET con 404 lanza NotFoundFailure con el mensaje de detail', () async {
      final mock = MockClient((request) async {
        return http.Response('{"detail": "Order 9 not found"}', 404,
            headers: {'content-type': 'application/json'});
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      expect(
        api.get('/orders/9'),
        throwsA(isA<NotFoundFailure>()
            .having((f) => f.message, 'message', 'Order 9 not found')),
      );
    });

    // 3. Conflicto
    test('PATCH con 409 lanza ConflictFailure con el mensaje de detail', () async {
      final mock = MockClient((request) async {
        return http.Response(
            '{"detail": "Cannot change status from pending to delivered"}',
            409,
            headers: {'content-type': 'application/json'});
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      expect(
        api.patch('/orders/1', {'status': 'delivered'}),
        throwsA(isA<ConflictFailure>().having(
            (f) => f.message,
            'message',
            'Cannot change status from pending to delivered')),
      );
    });

    // 4. Validación
    test('POST con 422 lanza ValidationFailure con el mapa de campos inválidos', () async {
      final mock = MockClient((request) async {
        final body = jsonEncode({
          'detail': [
            {
              'loc': ['body', 'customer'],
              'msg': 'Must be 1-50 characters',
            }
          ]
        });
        return http.Response(body, 422,
            headers: {'content-type': 'application/json'});
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      expect(
        api.post('/orders', {'customer': '', 'drink': 'te', 'size': 'M'}),
        throwsA(isA<ValidationFailure>().having(
          (f) => f.fields,
          'fields',
          {'customer': 'Must be 1-50 characters'},
        )),
      );
    });

    // 5. Servidor
    test('GET con 503 lanza ServerFailure con statusCode 503', () async {
      final mock = MockClient((request) async {
        return http.Response('{"detail": "Servicio no disponible"}', 503,
            headers: {'content-type': 'application/json'});
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      expect(
        api.get('/orders?fail=503'),
        throwsA(isA<ServerFailure>()
            .having((f) => f.statusCode, 'statusCode', 503)),
      );
    });

    // 6. Sin conexión o tiempo agotado
    group('Sin conexión o tiempo agotado', () {
      test('ClientException lanza NetworkFailure', () async {
        final mock = MockClient((request) async {
          throw http.ClientException('sin red');
        });
        final api = ApiClient(client: mock, baseUrl: 'http://prueba');

        expect(api.get('/orders'), throwsA(isA<NetworkFailure>()));
      });

      test('Petición que excede timeout lanza NetworkFailure', () async {
        final mock = MockClient((request) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return http.Response('[]', 200);
        });
        final api = ApiClient(
          client: mock,
          baseUrl: 'http://prueba',
          timeout: const Duration(milliseconds: 30),
        );

        expect(api.get('/orders'), throwsA(isA<NetworkFailure>()));
      });
    });

    // 7. Defecto D3: Código 300 no es éxito y lanza UnexpectedFailure
    test('Respuesta 300 no se considera éxito y lanza UnexpectedFailure', () async {
      final mock = MockClient((request) async {
        return http.Response('{"detail": "Multiple Choices"}', 300,
            headers: {'content-type': 'application/json'});
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      expect(
        api.get('/orders'),
        throwsA(isA<UnexpectedFailure>()
            .having((f) => f.statusCode, 'statusCode', 300)),
      );
    });
  });
}
