
// ignore_for_file: public_member_api_docs

import 'package:book_library/src/auth/models/register_request.dart';
import 'package:book_library/src/auth/models/user_db_model.dart';

abstract class AuthRepository {
  /// get all users
  Future<List<UserDbModel>> getAllUsers();

  /// get user by id
  Future<UserDbModel?> getUserById(String id);

  /// get user by email
  Future<UserDbModel?> getUserByEmail(String email);

  Future<List<UserDbModel>> getUserByName(String name);

  /// create user
  Future<UserDbModel> createUser(CreateUserReq userReq);

  /// update user
  /// [id] user id
  Future<UserDbModel> updateUser(String id, CreateUserReq userReq);

  /// delete user
  /// [id] user id
  Future<void> deleteUser(String id);

  Future<UserDbModel?> getUserProfile(String token);

  Future<UserDbModel?> changePassword(
      String token, String oldPassword, String newPassword,);
}
