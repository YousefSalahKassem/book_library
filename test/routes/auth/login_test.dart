// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:book_library/src/auth/models/login_request.dart';
import 'package:book_library/src/auth/models/login_response.dart';
import 'package:book_library/src/auth/models/user_db_model.dart';
import 'package:book_library/src/auth/services/auth_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

import '../../../routes/auth/login.dart' as route;

class MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockAuthServiceImpl extends Mock implements AuthServiceImpl {}

class MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late AuthServiceImpl authServiceImpl;
  late Uri uri;

  final responseModel = LoginResponse(
    user: UserDbModel(
      id: ObjectId(),
      name: 'name',
      email: 'email',
      password: 'password',
    ),
  );

  const requestModel = LoginReq(email: 'email', password: 'password');

  setUpAll(() => registerFallbackValue(requestModel));

  setUp(() {
    context = MockRequestContext();
    request = MockRequest();
    authServiceImpl = MockAuthServiceImpl();
    uri = MockUri();

    when(() => context.read<AuthServiceImpl>()).thenReturn(authServiceImpl);
    when(() => context.request).thenReturn(request);
    when(() => request.uri).thenReturn(uri);

    when(() => uri.resolve(any())).thenAnswer(
      (_) => Uri.parse('http://localhost:8080/auth/login'),
    );
    when(() => uri.queryParameters).thenReturn({});
  });

  group('Responds with 405', () {
    test('when the method is DELETE', () async {
      when(() => request.method).thenReturn(HttpMethod.delete);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is HEAD', () async {
      when(() => request.method).thenReturn(HttpMethod.head);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is OPTIONS', () async {
      when(() => request.method).thenReturn(HttpMethod.options);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is PATCH', () async {
      when(() => request.method).thenReturn(HttpMethod.patch);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is PUT', () async {
      when(() => request.method).thenReturn(HttpMethod.put);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is GET', () async {
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });

  group('POST /auth', () {
    test('returns a 400 for a bad request', () async {
      // Create a mock request and set its method to HttpMethod.post
      when(() => request.method).thenReturn(HttpMethod.post);

      // Set up the request to return null JSON data, representing a bad request
      when(() => request.json()).thenAnswer((_) async => null);

      // Call the route's onRequest method passing the mock request
      final response = await route.onRequest(context);

      // Assert that the response status code is 400 (HttpStatus.badRequest)
      expect(response.statusCode, equals(HttpStatus.badRequest));

      // Assert that the response body is empty (null)
    });

    test('POST /auth - Successful Login', () async {
      // Arrange
      when(() => request.method).thenReturn(HttpMethod.post);

      // Mock the request to return valid JSON data representing login credentials
      when(() => request.json()).thenAnswer(
        (_) async => {
          'email': 'email', // Replace with valid email
          'password': 'password', // Replace with valid password
        },
      );

      // Mock the AuthServiceImpl's login method to return the responseModel
      when(() => authServiceImpl.loginUser(any()))
          .thenAnswer((_) async => responseModel);

      // Act
      final response = await route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.ok));
    });
  });
}
