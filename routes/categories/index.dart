import 'dart:io';
import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/categories/models/category.dart';
import 'package:book_library/src/categories/models/category_db_model.dart';
import 'package:book_library/src/categories/services/category_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return MongoClient.startConnection(context, _addCategory(context));
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getCategories(context));
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getCategories(RequestContext context) async {
  try {
    final categoryServiceImpl = context.read<CategoryServiceImpl>();
    final requestJson = context.request.uri.queryParameters;

    final name = requestJson['name']?.toString();

    List<CategoryDbModel> categoryResponse;

    if (name != null && name.isNotEmpty) {
      final category = await categoryServiceImpl.getCategoryByName(name);
      if (category != null) {
        return Response.json(
          body: category.toMap(),
        );
      } else {
        return Response(statusCode: HttpStatus.notFound);
      }
    } else {
      categoryResponse = await categoryServiceImpl.getAllCategories();
      return Response.json(
        body: categoryResponse.map((e) => e.toMap()).toList(),
      );
    }
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'message': e.toString(),
      },
    );
  }
}

Future<Response> _addCategory(RequestContext context) async {
  try {
    final categoryServiceImpl = context.read<CategoryServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final categoryRequest = Category.fromMap(requestJson);
    final categoryResponse =
        await categoryServiceImpl.addCategory(categoryRequest);
    // ignore: lines_longer_than_80_chars
    return Response.json(
      body: categoryResponse.toMap(),
      statusCode: HttpStatus.created,
    );
  } catch (e) {
    // Return a 500 status code and the error message in the response body
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: e,
    );
  }
}
