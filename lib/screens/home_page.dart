import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_providers.dart';
import '../widgets/book_card_widget.dart';
import '../widgets/book_image_widget.dart';
import '../models/book.dart';
import 'book_detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(booksNotifierProvider);
    final notifier = ref.read(booksNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Club'),
        actions: [
          PopupMenuButton<SortBy>(
            onSelected: (s) => notifier.setSortBy(s),
            itemBuilder: (ctx) => [
              CheckedPopupMenuItem(
                value: SortBy.author,
                checked: state.sortBy == SortBy.author,
                child: const Text('Sort by Author'),
              ),
              CheckedPopupMenuItem(
                value: SortBy.title,
                checked: state.sortBy == SortBy.title,
                child: const Text('Sort by Title'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.books.isEmpty
              ? const Center(child: Text('No books yet'))
              : RefreshIndicator(
                  onRefresh: () => ref.read(booksNotifierProvider.notifier).init(),
                  child: ListView.builder(
                    itemCount: state.books.length,
                    itemBuilder: (context, index) {
                      final book = state.books[index];
                      // use the minimal image widget for a compact view; homework asked for by-author default listing
                      return BookCardWidget(
                        book: book,
                        onTap: () {
                          notifier.selectBook(book);
                          // navigate to detail page
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BookDetailPage(bookId: book.id),
                          ));
                        },
                        onDelete: () => notifier.deleteBook(book.id),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // For homework/demo purposes, create a new book with timestamp id
          final newBook = Book(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'New Book ${DateTime.now().second}',
            author: 'Author ${DateTime.now().second}',
            description: 'Added dynamically',
          );
          await notifier.addBook(newBook);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
