// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:book_library/src/categories/models/category_db_model.dart';
import 'package:book_library/src/categories/services/category_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

import '../../../routes/categories/index.dart' as route;

class MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockCategoryServiceImpl extends Mock implements CategoryServiceImpl {}

class MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late CategoryServiceImpl categoryServiceImpl;
  late Uri uri;

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
        'http://localhost:8080/categories',
      ),
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

  group('GET /categories', () {
    test('responds with a 200 and an empty list', () async {
      when(() => categoryServiceImpl.getAllCategories()).thenAnswer((_) async => []);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(isEmpty));

      verify(() => categoryServiceImpl.getAllCategories()).called(1);
    });

    test('responds with a 200 and a populated list of categories - getAllCategories',
        () async {
      when(() => categoryServiceImpl.getAllCategories())
          .thenAnswer((_) async => [category]);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals([category.toMap()]));

      verify(() => categoryServiceImpl.getAllCategories()).called(1);
    });

    test('responds with a 500 and an error message', () async {
      // Mock the behavior of the categoryServiceImpl.getAllcategories() method to throw an exception
      when(() => categoryServiceImpl.getAllCategories())
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

      // Verify that the categoryServiceImpl.getAllcategories() method is called exactly once
      verify(() => categoryServiceImpl.getAllCategories()).called(1);
    });
  });

  group('POST /categroes', () {
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
