// ignore_for_file: public_member_api_docs

import 'package:book_library/src/books/models/book.dart';
import 'package:book_library/src/books/models/book_db_model.dart';
import 'package:book_library/src/books/repositories/book_repository_impl.dart';
import 'package:book_library/src/books/services/book_service.dart';

class BookServiceImpl implements BookService {
  BookServiceImpl();

  final BookRepositoryImpl _bookRepository = BookRepositoryImpl();

  @override
  Future<BookDbModel> addBook(Book book) {
    try {
      return _bookRepository.addBook(book);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteBook(String id) {
    try {
      return _bookRepository.deleteBook(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BookDbModel>> getAllBooks() {
    try {
      return _bookRepository.getAllBooks();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BookDbModel?> getBookById(String id) {
    try {
      return _bookRepository.getBookById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BookDbModel> updateBook(String id, Book book) {
    try {
      return _bookRepository.updateBook(id, book);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BookDbModel>> searchByAuthor(String name) {
    try {
      return _bookRepository.searchByAuthor(name);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BookDbModel>> searchByCategory(String name) {
    try {
      return _bookRepository.searchByCategory(name);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BookDbModel>> searchByName(String name) {
    try {
      return _bookRepository.searchByName(name);
    } catch (e) {
      rethrow;
    }
  }
}
