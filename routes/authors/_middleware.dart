// ignore_for_file: lines_longer_than_80_chars

import 'package:book_library/src/authors/repositories/author_repository_impl.dart';
import 'package:book_library/src/authors/services/author_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) => handler.use(requestLogger()).use(repoProvider()).use(serviceProvider());

Middleware repoProvider() {
  return provider<AuthorRepositoryImpl>(
    (_) => AuthorRepositoryImpl(),
  );
}

Middleware serviceProvider() {
  return provider<AuthorServiceImpl>(
    (_) => AuthorServiceImpl(),
  );
}
