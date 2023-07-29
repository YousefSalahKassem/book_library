// ignore_for_file: public_member_api_docs

import 'package:dart_frog/dart_frog.dart';

typedef UserFromToken<User extends Object> = Future<User?> Function(
  RequestContext context,
  String token,
);
