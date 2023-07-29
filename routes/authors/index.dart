import 'dart:io';
import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/authors/models/author.dart';
import 'package:book_library/src/authors/models/author_db_model.dart';
import 'package:book_library/src/authors/services/author_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return MongoClient.startConnection(context, _addAuthor(context));
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getAuthors(context));
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getAuthors(RequestContext context) async {
  try {
    final authorServiceImpl = context.read<AuthorServiceImpl>();
    final requestJson = context.request.uri.queryParameters;

    final name = requestJson['name']?.toString();

    List<AuthorDbModel> authorResponse;

    if (name != null && name.isNotEmpty) {
      final category = await authorServiceImpl.getAuthorByName(name);
      if (category != null) {
        return Response.json(
          body: category.toMap(),
        );
      } else {
        return Response(statusCode: HttpStatus.notFound);
      }
    } else {
      authorResponse = await authorServiceImpl.getAllAuthors();
      return Response.json(
        body: authorResponse.map((e) => e.toMap()).toList(),
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

Future<Response> _addAuthor(RequestContext context) async {
  try {
    final authorServiceImpl = context.read<AuthorServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final authorRequest = Author.fromMap(requestJson);
    final authorResponse =
        await authorServiceImpl.addAuthor(authorRequest);
    // ignore: lines_longer_than_80_chars
    return Response.json(
      body: authorResponse.toMap(),
      statusCode: HttpStatus.created,
    );
  } catch (e) {
    // Return a 500 status code and the error message in the response body
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'message': 'An error occurred while processing the request.'},
    );
  }
}
