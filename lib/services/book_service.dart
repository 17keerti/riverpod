import 'dart:async';
import '../models/book.dart';

class BookService {
  final List<Book> _books = [];

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

}