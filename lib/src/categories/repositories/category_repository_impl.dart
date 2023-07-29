// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:book_library/config/mongo_client.dart';
import 'package:book_library/src/categories/models/category.dart';
import 'package:book_library/src/categories/models/category_db_model.dart';
import 'package:book_library/src/categories/repositories/category_repository.dart';
import 'package:book_library/utils/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl();

  final _mongoClient = MongoClient();

  @override
  Future<CategoryDbModel> addCategory(Category category) async {
    if (_mongoClient.db != null) {
      final collection =
          _mongoClient.db!.collection(Constants.categoryCollection);

      final results = await collection.insertOne(
        category.toMap(),
      );

      return CategoryDbModel.fromMap(results.document!);
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<List<CategoryDbModel>> getAllCategories() {
    if (_mongoClient.db != null) {
      final collection =
          _mongoClient.db!.collection(Constants.categoryCollection);
      return collection.find().map(CategoryDbModel.fromMap).toList();
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<CategoryDbModel?> getCategoryById(String id) async {
    if (_mongoClient.db != null) {
      final collection =
          _mongoClient.db!.collection(Constants.categoryCollection);
      final results = await collection.findOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
      );
      if (results != null) {
        return CategoryDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<CategoryDbModel?> getCategoryByName(String name) async {
    if (_mongoClient.db != null) {
      final collection =
          _mongoClient.db!.collection(Constants.categoryCollection);
      final results = await collection.findOne(
        where.eq(
          'title',
          name,
        ),
      );
      if (results != null) {
        return CategoryDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception(Constants.notConnected);
    }
  }

  @override
  Future<void> removeCategory(String id) {
    if (_mongoClient.db != null) {
      final collection =
          _mongoClient.db!.collection(Constants.categoryCollection);
      return collection.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
    } else {
      throw Exception(Constants.notConnected);
    }
  }
}
