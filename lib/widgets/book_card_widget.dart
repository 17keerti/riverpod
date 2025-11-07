import 'package:flutter/material.dart';
import '../models/book.dart';
import 'book_image_widget.dart';

/// Widget that displays image + title + author + description
class BookCardWidget extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const BookCardWidget({super.key, required this.book, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: BookImageWidget(book: book, size: 56),
        title: Text(book.title),
        subtitle: Text(book.author),
        isThreeLine: book.description.isNotEmpty,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
