// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/auth/models/register_request.dart';
import 'package:book_library/src/auth/models/user_db_model.dart';
import 'package:book_library/src/auth/repositories/auth_repository.dart';
import 'package:book_library/utils/constants.dart';
import 'package:book_library/utils/jwt_auth.dart';
import 'package:book_library/utils/password_utils.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  final _mongoClient = MongoClient();

  @override
  Future<UserDbModel?> changePassword(
    String token,
    String oldPassword,
    String newPassword,
  ) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authCollection);
      final user = await collection.findOne(where.eq('token', token));
      if (user != null) {
        final userDbModel = UserDbModel.fromMap(user);
        if (userDbModel.password ==
            PasswordUtils.encryptPassword(oldPassword)) {
          final updatedUser = userDbModel.copyWith(
            password: PasswordUtils.encryptPassword(newPassword),
          );
          final results = await collection.updateOne(
            where.eq('_id', updatedUser.id),
            updatedUser.toUpdateMap(),
          );


          if (results.isSuccess) {
            return updatedUser;
          } else {
            throw Exception(
              results.errmsg ?? 'An error occurred while updating the user',
            );
          }
        } else {
          throw Exception('Incorrect old password');
        }
      } else {
        throw Exception(Constants.notFound);
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<UserDbModel> createUser(CreateUserReq userReq) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authCollection);

      final results = await collection.insertOne(
        userReq
            .copyWith(
              token:
                  _generateToken( userReq.email),
            )
            .toMap(),
      );
      return UserDbModel.fromMap(results.document!);
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<void> deleteUser(String id) {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authCollection);
      return collection.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<List<UserDbModel>> getAllUsers() {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authCollection);
      return collection.find().map(UserDbModel.fromMap).toList();
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<UserDbModel?> getUserByEmail(String email) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authCollection);
      final results = await collection.findOne(where.eq('email', email));
      if (results != null) {
        final user = UserDbModel.fromMap(results);

        final updatedUser = await updateUser(
          user.id.$oid,
          CreateUserReq(
            name: user.name,
            email: user.email,
            password: user.password,
            token: _generateToken(
              user.email,
            ),
          ),
        );
        return updatedUser;
      } else {
        return null;
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<UserDbModel?> getUserById(String id) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authCollection);
      final results = await collection.findOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
      );
      if (results != null) {
        return UserDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<List<UserDbModel>> getUserByName(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authCollection);
      final results = await collection.find(where.eq('name', name)).toList();
      return results.map(UserDbModel.fromMap).toList();
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<UserDbModel?> getUserProfile(String token) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authCollection);
      final results = await collection.findOne(where.eq('token', token));
      if (results != null) {
        return UserDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<UserDbModel> updateUser(String id, CreateUserReq userReq) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authCollection);
      final userReqMap = userReq.toMap()..remove('password');
      final results = await collection.updateOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
        {
          r'$set': userReqMap,
        },
      );
      if (results.isSuccess) {
        final updatedUser = await getUserById(id);
        return updatedUser!;
      } else {
        throw Exception(results.errmsg ?? 'an error occured in updating user');
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  /// generate token for user
  String _generateToken(String email) {
    final claims = <String, dynamic>{
      'email': email,
    };

    final token = JWTUtilis.generateToken(claims);
    return token;
  }
}
