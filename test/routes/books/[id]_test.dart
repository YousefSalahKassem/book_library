// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:book_library/src/books/models/book_db_model.dart';
import 'package:book_library/src/books/services/book_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

import '../../../routes/books/[id].dart' as route;

class MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockBookServiceImpl extends Mock implements BookServiceImpl {}

class MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late BookServiceImpl bookServiceImpl;
  late Uri uri;

  const id = '64c2c3b53926b2a9969ac080';

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

  setUpAll(() => registerFallbackValue(bookModel));

  setUp(() {
    context = MockRequestContext();
    request = MockRequest();
    bookServiceImpl = MockBookServiceImpl();
    uri = MockUri();

    when(() => context.read<BookServiceImpl>()).thenReturn(bookServiceImpl);
    when(() => context.request).thenReturn(request);
    when(() => request.uri).thenReturn(uri);

    when(() => uri.resolve(any())).thenAnswer(
      (_) => Uri.parse(
          'http://localhost:8080/books${_.positionalArguments.first}',),
    );
    when(() => uri.queryParameters).thenReturn({});
  });

  group('Responds with 405', () {
    test('when the method is HEAD', () async {
      when(() => request.method).thenReturn(HttpMethod.head);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is OPTIONS', () async {
      when(() => request.method).thenReturn(HttpMethod.options);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is PATCH', () async {
      when(() => request.method).thenReturn(HttpMethod.patch);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when the method is POST', () async {
      when(() => request.method).thenReturn(HttpMethod.post);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });

  group('Responds with 404', () {
    test('if no book is found', () async {
      when(() => bookServiceImpl.getBookById(any()))
          .thenAnswer((_) async => null);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.notFound));

      verify(() => bookServiceImpl.getBookById(any(that: equals(id))))
          .called(1);
    });
  });

  group('GET /books/[id]', () {
    test('responds with a 200 and the book', () async {
      when(() => bookServiceImpl.getBookById(any()))
          .thenAnswer((_) async => bookModel);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(equals(bookModel.toMap())));

      verify(() => bookServiceImpl.getBookById(any(that: equals(id))))
          .called(1);
    });
  });

  group('DELETE /books/[id]', () {
    test('responds with a 204 and deletes the book', () async {
      when(() => bookServiceImpl.deleteBook(any()))
          .thenAnswer((_) async => true);
      when(() => request.method).thenReturn(HttpMethod.delete);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.noContent));

      verify(() => bookServiceImpl.deleteBook(any(that: equals(id)))).called(1);
    });
  });

}
