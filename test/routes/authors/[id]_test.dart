// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:book_library/src/authors/models/author_db_model.dart';
import 'package:book_library/src/authors/services/author_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

import '../../../routes/authors/[id].dart' as route;

class MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockAuthorServiceImpl extends Mock implements AuthorServiceImpl {}

class MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late AuthorServiceImpl authorServiceImpl;
  late Uri uri;

  const id = '64c2c3b53926b2a9969ac080';

  final authorModel = AuthorDbModel(id: ObjectId(), name: 'name', description: 'description', image: 'image', rate: 5);

  setUpAll(() => registerFallbackValue(authorModel));

  setUp(() {
    context = MockRequestContext();
    request = MockRequest();
    authorServiceImpl = MockAuthorServiceImpl();
    uri = MockUri();

    when(() => context.read<AuthorServiceImpl>()).thenReturn(authorServiceImpl);
    when(() => context.request).thenReturn(request);
    when(() => request.uri).thenReturn(uri);

    when(() => uri.resolve(any())).thenAnswer(
      (_) => Uri.parse(
          'http://localhost:8080/authors${_.positionalArguments.first}',),
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
    test('if no author is found', () async {
      when(() => authorServiceImpl.getAuthorById(any()))
          .thenAnswer((_) async => null);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.notFound));

      verify(() => authorServiceImpl.getAuthorById(any(that: equals(id))))
          .called(1);
    });
  });

  group('GET /authors/[id]', () {
    test('responds with a 200 and the author', () async {
      when(() => authorServiceImpl.getAuthorById(any()))
          .thenAnswer((_) async => authorModel);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(equals(authorModel.toMap())));

      verify(() => authorServiceImpl.getAuthorById(any(that: equals(id))))
          .called(1);
    });
  });

  group('DELETE /authors/[id]', () {
    test('responds with a 204 and deletes the author', () async {
      when(() => authorServiceImpl.removeAuthor(any()))
          .thenAnswer((_) async => true);
      when(() => request.method).thenReturn(HttpMethod.delete);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.noContent));

      verify(() => authorServiceImpl.removeAuthor(any(that: equals(id)))).called(1);
    });
  });

}
