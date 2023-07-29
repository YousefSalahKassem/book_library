// ignore_for_file: public_member_api_docs

import 'package:book_library/src/categories/models/category.dart';
import 'package:book_library/src/categories/models/category_db_model.dart';
import 'package:book_library/src/categories/repositories/category_repository_impl.dart';
import 'package:book_library/src/categories/services/category_service.dart';

class CategoryServiceImpl implements CategoryService {
  CategoryServiceImpl();

  final _categoryRepository = CategoryRepositoryImpl();

  @override
  Future<CategoryDbModel> addCategory(Category category) {
    try {
      return _categoryRepository.addCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryDbModel>> getAllCategories() {
    try {
      return _categoryRepository.getAllCategories();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CategoryDbModel?> getCategoryById(String id) {
    try {
      return _categoryRepository.getCategoryById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CategoryDbModel?> getCategoryByName(String name) {
    try {
      return _categoryRepository.getCategoryByName(name);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeCategory(String id) {
    try {
      return _categoryRepository.removeCategory(id);
    } catch (e) {
      rethrow;
    }
  }
}
