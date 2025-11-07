import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_providers.dart';
import '../widgets/book_card_widget.dart';
import 'book_detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(booksNotifierProvider);
    final notifier = ref.read(booksNotifierProvider.notifier);

    Widget buildSortButton(SortBy sortValue, String label) {
      final isSelected = state.sortBy == sortValue;
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ElevatedButton.icon(
          onPressed: () => notifier.setSortBy(sortValue),
          icon: isSelected ? const Icon(Icons.check, size: 16) : const SizedBox.shrink(),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.grey.shade100,
            foregroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: isSelected ? BorderSide(color: Theme.of(context).colorScheme.primary) : BorderSide.none,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Club'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Text('Sort by', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                buildSortButton(SortBy.author, 'Author'),
                buildSortButton(SortBy.title, 'Title'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
            child: Text(
              'Books',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.books.isEmpty
                    ? const Center(child: Text('No books yet'))
                    : RefreshIndicator(
                        onRefresh: () => ref.read(booksNotifierProvider.notifier).init(),
                        child: ListView.builder(
                          itemCount: state.books.length,
                          itemBuilder: (context, index) {
                            final book = state.books[index];
                            return BookCardWidget(
                              book: book,
                              onTap: () {
                                notifier.selectBook(book);
                                // navigate to detail page
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => BookDetailPage(bookId: book.id),
                                ));
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}