// ignore_for_file: lines_longer_than_80_chars

import 'package:book_library/src/categories/repositories/category_repository_impl.dart';
import 'package:book_library/src/categories/services/category_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) => handler.use(requestLogger()).use(repoProvider()).use(serviceProvider());

Middleware repoProvider() {
  return provider<CategoryRepositoryImpl>(
    (_) => CategoryRepositoryImpl(),
  );
}

Middleware serviceProvider() {
  return provider<CategoryServiceImpl>(
    (_) => CategoryServiceImpl(),
  );
}
