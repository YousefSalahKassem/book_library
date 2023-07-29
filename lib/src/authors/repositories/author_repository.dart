// ignore_for_file: public_member_api_docs

import 'package:book_library/src/authors/models/author.dart';
import 'package:book_library/src/authors/models/author_db_model.dart';

abstract class AuthorRepository {
  Future<List<AuthorDbModel>> getAllAuthors();

  Future<void> removeAuthor(String id);

  Future<AuthorDbModel?> getAuthorById(String id);

  Future<AuthorDbModel?> getAuthorByName(String name);

  Future<AuthorDbModel> addAuthor(Author author);

  Future<AuthorDbModel> updateAuthor(Author author, String id);
}
