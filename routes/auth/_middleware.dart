
import 'package:book_library/src/auth/repositories/auth_repository_impl.dart';
import 'package:book_library/src/auth/services/auth_service_impl.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  // ignore: lines_longer_than_80_chars
  return handler.use(requestLogger()).use(repoProvider()).use(serviceProvider());
}

Middleware repoProvider() {
  return provider<AuthRepositoryImpl>(
    (_) => AuthRepositoryImpl(),
  );
}

Middleware serviceProvider() {
  return provider<AuthServiceImpl>(
    (_) => AuthServiceImpl(),
  );
}
