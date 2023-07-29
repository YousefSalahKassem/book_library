// ignore_for_file: public_member_api_docs

import 'package:book_library/src/auth/models/login_request.dart';
import 'package:book_library/src/auth/models/login_response.dart';
import 'package:book_library/src/auth/models/register_request.dart';
import 'package:book_library/src/auth/models/user_db_model.dart';

abstract class AuthService {
  /// get all users
  Future<List<UserDbModel>> getAllUsers();

  /// get user by id
  Future<UserDbModel?> getUserById(String id);

  Future<List<UserDbModel>> getUserByName(String name);

  Future<UserDbModel?> getUserProfile(String token);

  /// get user by email
  Future<LoginResponse> loginUser(LoginReq request);

  /// create user
  Future<UserDbModel> registerUser(CreateUserReq userReq);

  /// update user
  /// [id] user id
  Future<UserDbModel> updateUser(String id, CreateUserReq userReq);

  /// delete user
  /// [id] user id
  Future<void> deleteUser(String id);

  Future<UserDbModel?> changePassword(
      String token, String oldPassword, String newPassword,);
}
