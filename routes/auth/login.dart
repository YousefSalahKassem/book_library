import 'dart:io';
import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/auth/models/login_request.dart';
import 'package:book_library/src/auth/services/auth_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';


Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
    return MongoClient.startConnection(context, _login(context));
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _login(RequestContext context) async {
  try {
    final userServiceImpl = context.read<AuthServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }
    final loginRequest = LoginReq.fromMap(requestJson);
    final userResponse = await userServiceImpl.loginUser(loginRequest);

    return Response.json(
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
