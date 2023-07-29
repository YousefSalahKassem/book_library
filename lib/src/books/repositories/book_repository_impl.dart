// ignore_for_file: public_member_api_docs

import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/books/models/book.dart';
import 'package:book_library/src/books/models/book_db_model.dart';
import 'package:book_library/src/books/repositories/book_repository.dart';
import 'package:book_library/utils/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class BookRepositoryImpl implements BookRepository {
  /// UserRepositoryImpl
  BookRepositoryImpl();

  final MongoClient _mongoClient = MongoClient();

  @override
  Future<BookDbModel> addBook(Book book) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.bookCollection);
      final results = await collection.insertOne(book.toMap());
      return BookDbModel.fromMap(results.document!);
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<void> deleteBook(String id) {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.bookCollection);
      return collection.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<List<BookDbModel>> getAllBooks() {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.bookCollection);
      return collection.find().map(BookDbModel.fromMap).toList();
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<BookDbModel?> getBookById(String id) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.bookCollection);
      final results = await collection.findOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
      );
      if (results != null) {
        return BookDbModel.fromMap(results);
      } else {
        throw Exception(Constants.notFound);
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

@override
Future<BookDbModel> updateBook(String id, Book book) async {
  if (_mongoClient.db == null) {
    throw Exception(Constants.notConnected);
  }

  final collection = _mongoClient.db!.collection(Constants.bookCollection);
  final updateResult = await collection.updateOne(
    where.eq('_id', ObjectId.fromHexString(id)),
    book.toUpdateMap(),
  );

  if (updateResult.nModified == 1) {
    final updatedBook = await collection.findOne(
      where.eq('_id', ObjectId.fromHexString(id)),
    );
    if (updatedBook != null) {
      return BookDbModel.fromMap(updatedBook);
    } else {
      throw Exception(Constants.failedToFind);
    }
  } else {
    throw Exception(Constants.failedToUpdate);
  }
}


  @override
  Future<List<BookDbModel>> searchByAuthor(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.bookCollection);
      final results = await collection
          .find(
            where.eq(
              'author',
              name,
            ),
          )
          .toList();
      return results.map(BookDbModel.fromMap).toList();
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<List<BookDbModel>> searchByCategory(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.bookCollection);
      final results = await collection
          .find(
            where.eq(
              'category',
              name,
            ),
          )
          .toList();
      return results.map(BookDbModel.fromMap).toList();
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<List<BookDbModel>> searchByName(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection(Constants.bookCollection);
      final results = await collection
          .find(
            where.eq(
              'headline',
              name,
            ),
          )
          .toList();
      return results.map(BookDbModel.fromMap).toList();
    } else {
      throw Exception(Constants.notConnected);
    }
  }
}
