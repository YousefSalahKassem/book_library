// ignore_for_file: public_member_api_docs

import 'package:book_library/src/auth/models/login_request.dart';
import 'package:book_library/src/auth/models/login_response.dart';
import 'package:book_library/src/auth/models/register_request.dart';
import 'package:book_library/src/auth/models/user_db_model.dart';
import 'package:book_library/src/auth/repositories/auth_repository_impl.dart';
import 'package:book_library/src/auth/services/auth_service.dart';
import 'package:book_library/utils/password_utils.dart';

class AuthServiceImpl extends AuthService {
  AuthServiceImpl();

  final _authRepository = AuthRepositoryImpl();

  @override
  Future<UserDbModel> registerUser(CreateUserReq userReq) async {
    try {
      final userReqClone = userReq.copyWith(
        password: PasswordUtils.encryptPassword(userReq.password),
      );
      // check if user already exists
      final user = await _authRepository.getUserByEmail(userReqClone.email);
      if (user != null) {
        throw Exception('User already exists');
      }
      return _authRepository.createUser(userReqClone);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginResponse> loginUser(LoginReq request) async {
    try {
      // check if user already exists
      final user = await _authRepository.getUserByEmail(request.email);
      if (user == null) {
        throw Exception('User does not exists');
      }
      if (user.password != PasswordUtils.encryptPassword(request.password)) {
        throw Exception('Invalid email address or password');
      }

      // return
      return LoginResponse(
        user: user,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String id) {
    try {
      return _authRepository.deleteUser(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDbModel?> getUserById(String id) {
    try {
      return _authRepository.getUserById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserDbModel>> getUserByName(String name) {
    try {
      return _authRepository.getUserByName(name);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDbModel?> getUserProfile(String token) {
    try {
      return _authRepository.getUserProfile(token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDbModel> updateUser(String id, CreateUserReq userReq) {
    try {
      return _authRepository.updateUser(id, userReq);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserDbModel>> getAllUsers() {
    try {
      return _authRepository.getAllUsers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDbModel?> changePassword(
      String token, String oldPassword, String newPassword,) {
    try {
      return _authRepository.changePassword(token, oldPassword, newPassword,);
    } catch (e) {
      rethrow;
    }
  }
}
