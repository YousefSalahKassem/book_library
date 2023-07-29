import 'package:book_library/utils/jwt_auth.dart';
import 'package:test/test.dart';

void main() {
  group('JWTUtilis', () {
    final claims = <String, dynamic>{'userId': 1234, 'isAdmin': true};

    test('Generate and validate token', () {
      final token = JWTUtilis.generateToken(claims);
      expect(token, isNotNull);

      final isValid = JWTUtilis.isTokenValid(token);
      expect(isValid, isTrue);
    });

    test('Generate and validate refresh token', () {
      final refreshToken = JWTUtilis.generateRefreshToken(claims);
      expect(refreshToken, isNotNull);

      final isValid = JWTUtilis.isTokenValid(refreshToken);
      expect(isValid, isTrue);
    });

    test('Invalid token validation', () {
      // We are using an arbitrary string as a token, which will be invalid.
      const invalidToken = 'invalid-token';
      final isValid = JWTUtilis.isTokenValid(invalidToken);
      expect(isValid, isFalse);
    });
  });
}
