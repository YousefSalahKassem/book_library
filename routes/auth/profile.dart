import 'dart:io';
import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/auth/services/auth_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, _profile(context));
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _profile(RequestContext context) async {
  try {
    final userServiceImpl = context.read<AuthServiceImpl>();
    // ignore: lines_longer_than_80_chars
    final authorizationHeader =
        context.request.headers[HttpHeaders.authorizationHeader];
    final token = authorizationHeader?.split('Bearer ')[1];
    final userResponse = await userServiceImpl.getUserProfile(token!);

    if (userResponse != null) {
      return Response.json(
        body: userResponse.toMap(),
      );
    } else {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Profile Not Found',
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
