// ignore_for_file: public_member_api_docs
import 'package:book_library/utils/constants.dart';
import 'package:encrypt/encrypt.dart';

mixin PasswordUtils {
  
  /// encrypt the password using AES encryption
  static String encryptPassword(String password) {
    final key = Key.fromUtf8(Constants.passwordLongSecret);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  /// decrypt the password using AES encryption
  static String decryptPassword(String password) {
    final key = Key.fromUtf8(Constants.passwordLongSecret);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(password, iv: iv);
    return decrypted;
  }
}
