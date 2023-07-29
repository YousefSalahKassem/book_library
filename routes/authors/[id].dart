import 'dart:io';
import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/authors/models/author.dart';
import 'package:book_library/src/authors/services/author_service_impl.dart';
import 'package:book_library/utils/constants.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getById(context, id));
    case HttpMethod.delete:
      return MongoClient.startConnection(context, _deleteById(context, id));
    case HttpMethod.put:
      return MongoClient.startConnection(context, _putById(context, id));
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getById(RequestContext context, String id) async {
  try {
    final authorServiceImpl = context.read<AuthorServiceImpl>();

    final authorResponse = await authorServiceImpl.getAuthorById(id);

    if (authorResponse != null) {
      return Response.json(
        body: authorResponse.toMap(),
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
    final authorServiceImpl = context.read<AuthorServiceImpl>();
    await authorServiceImpl.removeAuthor(id);
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

Future<Response> _putById(RequestContext context, String id) async {
  try {
    final authorServiceImpl = context.read<AuthorServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }
    final authorRequest = Author.fromMap(requestJson);
    final author = await authorServiceImpl.updateAuthor(authorRequest, id);
    return Response.json(
      body: author.toMap(),
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'message': e.toString(),
      },
    );
  }
}
