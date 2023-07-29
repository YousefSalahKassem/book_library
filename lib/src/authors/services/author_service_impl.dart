// ignore_for_file: public_member_api_docs

import 'package:book_library/src/authors/models/author.dart';
import 'package:book_library/src/authors/models/author_db_model.dart';
import 'package:book_library/src/authors/repositories/author_repository_impl.dart';
import 'package:book_library/src/authors/services/author_service.dart';

class AuthorServiceImpl extends AuthorService {
  AuthorServiceImpl();

  final AuthorRepositoryImpl _authorRepository = AuthorRepositoryImpl();

  @override
  Future<AuthorDbModel> addAuthor(Author author) {
    try {
      return _authorRepository.addAuthor(author);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AuthorDbModel>> getAllAuthors() {
    try {
      return _authorRepository.getAllAuthors();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthorDbModel?> getAuthorById(String id) {
    try {
      return _authorRepository.getAuthorById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthorDbModel?> getAuthorByName(String name) {
    try {
      return _authorRepository.getAuthorByName(name);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeAuthor(String id) {
    try {
      return _authorRepository.removeAuthor(id);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<AuthorDbModel> updateAuthor(Author author, String id) {
   try {
      return _authorRepository.updateAuthor(author,id);
    } catch (e) {
      rethrow;
    }
  }
}
