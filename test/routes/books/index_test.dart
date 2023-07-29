// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:book_library/src/books/models/book.dart';
import 'package:book_library/src/books/models/book_db_model.dart';
import 'package:book_library/src/books/services/book_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

import '../../../routes/books/index.dart' as route;

class MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockBookServiceImpl extends Mock implements BookServiceImpl {}

class MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late BookServiceImpl bookServiceImpl;
  late Uri uri;

  final bookModel = BookDbModel(
    id: ObjectId(),
    author: 'John Doe',
    headline: 'Sample5 Book',
    leadParagraph: 'This is a sample book.',
    imageUrl: 'https://example.com/book.jpg',
    createdAt: '2023-05-20T10:30:00Z',
    modifiedAt: '2023-05-20T15:45:00Z',
    rate: 4,
    category: 'Horror',
  );

  const book = Book(
    author: 'John Doe',
    headline: 'Sample5 Book',
    leadParagraph: 'This is a sample book.',
    imageUrl: 'https://example.com/book.jpg',
    createdAt: '2023-05-20T10:30:00Z',
    modifiedAt: '2023-05-20T15:45:00Z',
    rate: 4,
    category: 'Horror',
  );

  setUpAll(() => registerFallbackValue(book));

  setUp(() {
    context = MockRequestContext();
    request = MockRequest();
    bookServiceImpl = MockBookServiceImpl();
    uri = MockUri();

    when(() => context.read<BookServiceImpl>()).thenReturn(bookServiceImpl);
    when(() => context.request).thenReturn(request);
    when(() => request.uri).thenReturn(uri);

    when(() => uri.resolve(any())).thenAnswer(
      (_) => Uri.parse('http://localhost:8080/books'),
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

  group('GET /books', () {
    test('responds with a 200 and an empty list', () async {
      when(() => bookServiceImpl.getAllBooks()).thenAnswer((_) async => []);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(isEmpty));

      verify(() => bookServiceImpl.getAllBooks()).called(1);
    });

    test('responds with a 200 and a populated list of books - getAllBooks',
        () async {
      when(() => bookServiceImpl.getAllBooks())
          .thenAnswer((_) async => [bookModel]);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals([bookModel.toMap()]));

      verify(() => bookServiceImpl.getAllBooks()).called(1);
    });

    test('responds with a 500 and an error message', () async {
      // Mock the behavior of the bookServiceImpl.getAllBooks() method to throw an exception
      when(() => bookServiceImpl.getAllBooks())
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

      // Verify that the bookServiceImpl.getAllBooks() method is called exactly once
      verify(() => bookServiceImpl.getAllBooks()).called(1);
    });
  });

  group('POST /books', () {
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
