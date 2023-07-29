import 'dart:io';
import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/auth/services/auth_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.put:
      return MongoClient.startConnection(context, _changePassword(context));
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _changePassword(RequestContext context) async {
  try {
    final userServiceImpl = context.read<AuthServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    final authorizationHeader =
        context.request.headers[HttpHeaders.authorizationHeader];
    final token = authorizationHeader?.split('Bearer ')[1];
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }
    final user =
        await userServiceImpl.changePassword(
          token!,
          requestJson['oldPassword'].toString(),
          requestJson['newPassword'].toString(),
          );

    if (user == null) {
      return Response(statusCode: HttpStatus.unauthorized);
    } else {
      return Response.json(
      body: user.toMap()..remove('password'),
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
