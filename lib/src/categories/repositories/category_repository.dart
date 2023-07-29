// ignore_for_file: public_member_api_docs

import 'package:book_library/src/categories/models/category.dart';
import 'package:book_library/src/categories/models/category_db_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryDbModel>> getAllCategories();

  Future<void> removeCategory(String id);

  Future<CategoryDbModel?> getCategoryById(String id);

  Future<CategoryDbModel> addCategory(Category category);

  Future<CategoryDbModel?> getCategoryByName(String name);
}
