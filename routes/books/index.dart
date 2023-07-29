import 'dart:io';
import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/books/models/book.dart';
import 'package:book_library/src/books/models/book_db_model.dart';
import 'package:book_library/src/books/services/book_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return MongoClient.startConnection(context, _addBook(context));
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getBooks(context));
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getBooks(RequestContext context) async {
  try {
    final bookServiceImpl = context.read<BookServiceImpl>();
    final requestJson = context.request.uri.queryParameters;

    final bookName = requestJson['bookName']?.toString();
    final categoryName = requestJson['categoryName']?.toString();
    final authorName = requestJson['authorName']?.toString();

    List<BookDbModel> bookResponse;

    if (authorName != null && authorName.isNotEmpty) {
      bookResponse = await bookServiceImpl.searchByAuthor(authorName);
    } else if (bookName != null && bookName.isNotEmpty) {
      bookResponse = await bookServiceImpl.searchByName(bookName);
    } else if (categoryName != null && categoryName.isNotEmpty) {
      bookResponse = await bookServiceImpl.searchByCategory(categoryName);
    } else {
      bookResponse = await bookServiceImpl.getAllBooks();
    }

    return Response.json(
      body: bookResponse.map((e) => e.toMap()).toList(),
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

Future<Response> _addBook(RequestContext context) async {
  try {
    final bookServiceImpl = context.read<BookServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final bookRequest = Book.fromMap(requestJson);
    final bookResponse = await bookServiceImpl.addBook(bookRequest);
    // ignore: lines_longer_than_80_chars
    return Response.json(
      body: bookResponse.toMap(),
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
