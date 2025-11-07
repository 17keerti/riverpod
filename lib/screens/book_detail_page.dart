import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_providers.dart';
import '../widgets/book_image_widget.dart';

class BookDetailPage extends ConsumerWidget {
  final String bookId;
  const BookDetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(booksNotifierProvider);
    final notifier = ref.read(booksNotifierProvider.notifier);

    final book = state.books.firstWhere((b) => b.id == bookId, orElse: () => state.selectedBook ?? (state.books.isNotEmpty ? state.books[0] : throw Exception('Book not found')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            notifier.backToList();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: BookImageWidget(book: book, size: 140)),
            const SizedBox(height: 16),
            Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('by ${book.author}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text(book.description),
            const Spacer(),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    notifier.backToList();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('Back to List'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}