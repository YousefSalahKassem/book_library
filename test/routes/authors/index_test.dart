// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:book_library/src/authors/models/author.dart';
import 'package:book_library/src/authors/models/author_db_model.dart';
import 'package:book_library/src/authors/services/author_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

import '../../../routes/authors/index.dart' as route;

class MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockAuthorServiceImpl extends Mock implements AuthorServiceImpl {}

class MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late AuthorServiceImpl authorServiceImpl;
  late Uri uri;

  final authorModel = AuthorDbModel(
    id: ObjectId(),
    name: 'name',
    description: 'description',
    image: 'image',
    rate: 5,
  );

  const author = Author(
    name: 'name',
    description: 'description',
    image: 'image',
    rate: 5,
  );

  setUpAll(() => registerFallbackValue(author));

  setUp(() {
    context = MockRequestContext();
    request = MockRequest();
    authorServiceImpl = MockAuthorServiceImpl();
    uri = MockUri();

    when(() => context.read<AuthorServiceImpl>()).thenReturn(authorServiceImpl);
    when(() => context.request).thenReturn(request);
    when(() => request.uri).thenReturn(uri);

    when(() => uri.resolve(any())).thenAnswer(
      (_) => Uri.parse('http://localhost:8080/authors'),
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
  });

  group('GET /authors', () {
    test('responds with a 200 and an empty list', () async {
      when(() => authorServiceImpl.getAllAuthors()).thenAnswer((_) async => []);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(isEmpty));

      verify(() => authorServiceImpl.getAllAuthors()).called(1);
    });

    test('responds with a 200 and a populated list of authors - getAllAuthors',
        () async {
      when(() => authorServiceImpl.getAllAuthors())
          .thenAnswer((_) async => [authorModel]);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals([authorModel.toMap()]));

      verify(() => authorServiceImpl.getAllAuthors()).called(1);
    });

    test('responds with a 500 and an error message', () async {
      // Mock the behavior of the AuthorServiceImpl.getAllAuthors() method to throw an exception
      when(() => authorServiceImpl.getAllAuthors())
          .thenThrow(Exception('Database error'));

      // Create a mock request and set its method to HttpMethod.get
      when(() => request.method).thenReturn(HttpMethod.get);

      // Call the route's onRequest method passing the mock request
      final response = await route.onRequest(context);

      // Assert that the response status code is 500 (HttpStatus.internalServerError)
      expect(response.statusCode, equals(HttpStatus.internalServerError));

      // Assert that the response body is an error message (in this case, it could be a JSON object with an "message" field)
      expect(
        await response.json(),
        equals({'message': 'Exception: Database error'}),
      );

      // Verify that the AuthorServiceImpl.getAllAuthors() method is called exactly once
      verify(() => authorServiceImpl.getAllAuthors()).called(1);
    });
  });

  group('POST /authors', () {
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
  });
}
