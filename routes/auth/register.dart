import 'dart:io';

import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/auth/models/register_request.dart';
import 'package:book_library/src/auth/services/auth_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
    return MongoClient.startConnection(context, _register(context));
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _register(RequestContext context) async {
  try {
    final userServiceImpl = context.read<AuthServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }
    final userRequest = CreateUserReq.fromMap(requestJson);
    final userResponse = await userServiceImpl.registerUser(userRequest);
    return Response.json(
      statusCode: HttpStatus.created,
      body: userResponse.toMap(),
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
