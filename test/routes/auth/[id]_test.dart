// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:book_library/src/auth/models/user_db_model.dart';
import 'package:book_library/src/auth/services/auth_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

import '../../../routes/auth/[id].dart' as route;

class MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockAuthServiceImpl extends Mock implements AuthServiceImpl {}

class MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late AuthServiceImpl authServiceImpl;
  late Uri uri;

  final responseModel = UserDbModel(
      id: ObjectId(),
      name: 'name',
      email: 'email',
      password: 'password',
    );

  const id = '1';

  setUpAll(() => registerFallbackValue(id));

  setUp(() {
    context = MockRequestContext();
    request = MockRequest();
    authServiceImpl = MockAuthServiceImpl();
    uri = MockUri();

    when(() => context.read<AuthServiceImpl>()).thenReturn(authServiceImpl);
    when(() => context.request).thenReturn(request);
    when(() => request.uri).thenReturn(uri);

    when(() => uri.resolve(any())).thenAnswer(
      (_) => Uri.parse('http://localhost:8080/auth${_.positionalArguments.first}'),
    );
    when(() => uri.queryParameters).thenReturn({});
  });

  group('Responds with 405', () {
    test('when the method is POST', () async {
      when(() => request.method).thenReturn(HttpMethod.post);

      final response = await route.onRequest(context,id);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is HEAD', () async {
      when(() => request.method).thenReturn(HttpMethod.head);

      final response = await route.onRequest(context,id);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is OPTIONS', () async {
      when(() => request.method).thenReturn(HttpMethod.options);

      final response = await route.onRequest(context,id);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is PATCH', () async {
      when(() => request.method).thenReturn(HttpMethod.patch);

      final response = await route.onRequest(context,id);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is PUT', () async {
      when(() => request.method).thenReturn(HttpMethod.put);

      final response = await route.onRequest(context,id);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });


  group('GET /authors/[id]', () {
    test('responds with a 200 and the user', () async {
      when(() => authServiceImpl.getUserById(any()))
          .thenAnswer((_) async => responseModel);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(equals(responseModel.toMap())));

      verify(() => authServiceImpl.getUserById(any(that: equals(id))))
          .called(1);
    });
  });

  group('DELETE /authors/[id]', () {
    test('responds with a 204 and deletes the author', () async {
      when(() => authServiceImpl.deleteUser(any()))
          .thenAnswer((_) async => true);
      when(() => request.method).thenReturn(HttpMethod.delete);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.noContent));

      verify(() => authServiceImpl.deleteUser(any(that: equals(id)))).called(1);
    });
  });
}
