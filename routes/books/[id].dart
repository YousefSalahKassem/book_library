import 'dart:io';
import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/books/models/book.dart';
import 'package:book_library/src/books/services/book_service_impl.dart';
import 'package:book_library/utils/constants.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getById(context, id));
          case HttpMethod.put:
      return MongoClient.startConnection(context, _putById(context, id));
    case HttpMethod.delete:
      return MongoClient.startConnection(context, _deleteById(context, id));

    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getById(RequestContext context, String id) async {
  try {
    final bookServiceImpl = context.read<BookServiceImpl>();

    final bookResponse = await bookServiceImpl.getBookById(id);

    if (bookResponse != null) {
      return Response.json(
        body: bookResponse.toMap(),
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
    final bookServiceImpl = context.read<BookServiceImpl>();
    await bookServiceImpl.deleteBook(id);
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
    final bookServiceImpl = context.read<BookServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }
    final bookRequest = Book.fromMap(requestJson);
    final book = await bookServiceImpl.updateBook(id, bookRequest);
    return Response.json(
      body: book.toMap(),
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
