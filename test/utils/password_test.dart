// ignore_for_file: lines_longer_than_80_chars

import 'package:book_library/utils/password_utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('PasswordUtils', () {

    test('Encrypt and decrypt password', () {
      const originalPassword = 'mySecretPassword123';

      // Encrypt the password
      final encryptedPassword = PasswordUtils.encryptPassword(originalPassword);
      expect(encryptedPassword, isNotNull);

      // Decrypt the password
      final decryptedPassword = PasswordUtils.decryptPassword(encryptedPassword);
      expect(decryptedPassword, originalPassword);
    });
  });
}
