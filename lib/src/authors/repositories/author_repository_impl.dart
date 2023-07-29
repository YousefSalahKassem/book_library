
// ignore_for_file: lines_longer_than_80_chars

import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/authors/models/author.dart';
import 'package:book_library/src/authors/models/author_db_model.dart';
import 'package:book_library/src/authors/repositories/author_repository.dart';
import 'package:book_library/utils/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

// ignore: public_member_api_docs
class AuthorRepositoryImpl implements AuthorRepository {
  /// UserRepositoryImpl
  AuthorRepositoryImpl();

  final MongoClient _mongoClient = MongoClient();

  @override
  Future<AuthorDbModel> addAuthor(Author author) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authorsCollection);

      final results = await collection.insertOne(
        author.toMap(),
      );

      return AuthorDbModel.fromMap(results.document!);
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<List<AuthorDbModel>> getAllAuthors() {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authorsCollection);
      return collection.find().map(AuthorDbModel.fromMap).toList();
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<AuthorDbModel?> getAuthorById(String id) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authorsCollection);
      final results = await collection.findOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
      );
      if (results != null) {
        return AuthorDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<AuthorDbModel?> getAuthorByName(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authorsCollection);
      final results = await collection.findOne(
        where.eq(
          'name',
          name,
        ),
      );
      if (results != null) {
        return AuthorDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<void> removeAuthor(String id) {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.authorsCollection);
      return collection.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
    } else {
      throw Exception(Constants.notConnected);
    }
  }
  
  @override
  Future<AuthorDbModel> updateAuthor(Author author, String id) async {
 if (_mongoClient.db == null) {
    throw Exception(Constants.notConnected);
  }

  final collection = _mongoClient.db!.collection(Constants.authorsCollection);
  final updateResult = await collection.updateOne(
    where.eq('_id', ObjectId.fromHexString(id)),
    author.toUpdateMap(),
  );

  if (updateResult.nModified == 1) {
    final updatedAuthor = await collection.findOne(
      where.eq('_id', ObjectId.fromHexString(id)),
    );
    if (updatedAuthor != null) {
      return AuthorDbModel.fromMap(updatedAuthor);
    } else {
      throw Exception(Constants.failedToFind);
    }
  } else {
    throw Exception(Constants.failedToUpdate);
  }
  }
}
