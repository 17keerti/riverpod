import 'dart:async';
import '../models/book.dart';

/// Mock service: starts with empty list and provides a method
/// to "seed" the list (which the notifier will call in init()).
class BookService {
  final List<Book> _books = [];

  /// Initially empty — we simulate filling books in init() by calling seedBooks()
  Future<List<Book>> fetchBooks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Book>.from(_books);
  }

  Future<void> seedBooks(List<Book> books) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_books.isEmpty) {
      _books.addAll(books);
    }
  }

  // NOTE: addBook and deleteBook methods removed as per request.
}