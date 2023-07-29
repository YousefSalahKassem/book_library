import 'dart:io';
import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/categories/services/category_service_impl.dart';
import 'package:book_library/utils/constants.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getById(context, id));
    case HttpMethod.delete:
      return MongoClient.startConnection(context, _deleteById(context, id));
    case HttpMethod.put:
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getById(RequestContext context, String id) async {
  try {
    final categoryServiceImpl = context.read<CategoryServiceImpl>();

    final categoryResponse = await categoryServiceImpl.getCategoryById(id);

    if (categoryResponse != null) {
      return Response.json(
        body: categoryResponse.toMap(),
      );
    } else {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {
          'message': Constants.notFound,
        },
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

Future<Response> _deleteById(RequestContext context, String id) async {
  try {
    final categoryServiceImpl = context.read<CategoryServiceImpl>();
    await categoryServiceImpl.removeCategory(id);
    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'message': e.toString(),
      },
    );
  }
}
