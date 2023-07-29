// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:book_library/src/categories/models/category_db_model.dart';
import 'package:book_library/src/categories/services/category_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

import '../../../routes/categories/[id].dart' as route;

class MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockCategoryServiceImpl extends Mock implements CategoryServiceImpl {}

class MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late CategoryServiceImpl categoryServiceImpl;
  late Uri uri;

  const id = '64c2c3b53926b2a9969ac080';

  final category = CategoryDbModel(id: ObjectId(), title: 'Horror');

  setUpAll(() => registerFallbackValue(category));

  setUp(() {
    context = MockRequestContext();
    request = MockRequest();
    categoryServiceImpl = MockCategoryServiceImpl();
    uri = MockUri();

    when(() => context.read<CategoryServiceImpl>())
        .thenReturn(categoryServiceImpl);
    when(() => context.request).thenReturn(request);
    when(() => request.uri).thenReturn(uri);

    when(() => uri.resolve(any())).thenAnswer(
      (_) => Uri.parse(
        'http://localhost:8080/categories${_.positionalArguments.first}',
      ),
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
    test('if no category is found', () async {
      when(() => categoryServiceImpl.getCategoryById(any()))
          .thenAnswer((_) async => null);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.notFound));

      verify(() => categoryServiceImpl.getCategoryById(any(that: equals(id))))
          .called(1);
    });
  });

  group('GET /categories/[id]', () {
    test('responds with a 200 and the category', () async {
      when(() => categoryServiceImpl.getCategoryById(any()))
          .thenAnswer((_) async => category);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(equals(category.toMap())));

      verify(() => categoryServiceImpl.getCategoryById(any(that: equals(id))))
          .called(1);
    });
  });

  group('DELETE /categories/[id]', () {
    test('responds with a 204 and deletes the category', () async {
      when(() => categoryServiceImpl.removeCategory(any()))
          .thenAnswer((_) async => true);
      when(() => request.method).thenReturn(HttpMethod.delete);

      final response = await route.onRequest(context, id);

      expect(response.statusCode, equals(HttpStatus.noContent));

      verify(() => categoryServiceImpl.removeCategory(any(that: equals(id))))
          .called(1);
    });
  });
}
