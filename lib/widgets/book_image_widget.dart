import 'package:flutter/material.dart';
import '../models/book.dart';

/// Widget that displays only the book image (or a placeholder).
class BookImageWidget extends StatelessWidget {
  final Book book;
  final double size;
  const BookImageWidget({super.key, required this.book, this.size = 56});

  @override
  Widget build(BuildContext context) {
    if (book.imageUrl.isNotEmpty) {
      return Image.network(
        book.imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
    // Placeholder box with initials
    final initials = _getInitials(book.title);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(initials, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  String _getInitials(String text) {
    final parts = text.split(' ');
    if (parts.isEmpty) return text.substring(0, 1);
    if (parts.length == 1) return parts[0].substring(0, 1);
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
