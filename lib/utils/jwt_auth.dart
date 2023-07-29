// ignore_for_file: public_member_api_docs
import 'package:book_library/utils/constants.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

mixin JWTUtilis {
  static const String secretKey = Constants.jwtSecretKey;

  /// generate token
  static String generateToken(Map<String, dynamic> claims) {
    final jwt = JWT(
      claims,
      issuer: Constants.jwtIssuerLink,
    );

    return jwt.sign(
      SecretKey(secretKey),
      algorithm: JWTAlgorithm.HS512,
      expiresIn: const Duration(minutes: 120),
    );
  }

  /// generate refresh token
  static String generateRefreshToken(Map<String, dynamic> claims) {
    final jwt = JWT(
      claims,
      issuer: Constants.jwtIssuerLink,
    );
    return jwt.sign(
      SecretKey(secretKey),
      expiresIn: const Duration(days: 30),
    );
  }

  /// check if the JWT is valid
  static bool isTokenValid(String token) {
    try {
      JWT.verify(token, SecretKey(secretKey));
      return true;
    } on JWTException {
      return false;
    } catch (_){
      return false;
    }
  }
}
