// ignore_for_file: lines_longer_than_80_chars

import 'package:book_library/src/books/repositories/book_repository_impl.dart';
import 'package:book_library/src/books/services/book_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) => handler.use(requestLogger()).use(repoProvider()).use(serviceProvider());

Middleware repoProvider() {
  return provider<BookRepositoryImpl>(
    (_) => BookRepositoryImpl(),
  );
}

Middleware serviceProvider() {
  return provider<BookServiceImpl>(
    (_) => BookServiceImpl(),
  );
}
