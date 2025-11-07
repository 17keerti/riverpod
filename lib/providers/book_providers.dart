import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../services/book_service.dart';

/// Sorting option
enum SortBy { author, title }

/// The state used by the Notifier
class BooksState {
  final List<Book> books;
  final bool isLoading;
  final SortBy sortBy;
  final Book? selectedBook;

  const BooksState({
    required this.books,
    required this.isLoading,
    required this.sortBy,
    required this.selectedBook,
  });

  factory BooksState.initial() {
    return const BooksState(
      books: [],
      isLoading: false,
      sortBy: SortBy.author,
      selectedBook: null,
    );
  }

  BooksState copyWith({
    List<Book>? books,
    bool? isLoading,
    SortBy? sortBy,
    Book? selectedBook, // pass null to clear selection
  }) {
    return BooksState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      sortBy: sortBy ?? this.sortBy,
      selectedBook: selectedBook,
    );
  }
}

/// Providers
final bookServiceProvider = Provider<BookService>((ref) => BookService());

final booksNotifierProvider =
    StateNotifierProvider<BooksNotifier, BooksState>((ref) {
  return BooksNotifier(ref);
});

/// Notifier that acts like a Cubit/Bloc
class BooksNotifier extends StateNotifier<BooksState> {
  final Ref ref;
  BooksNotifier(this.ref) : super(BooksState.initial()) {
    init();
  }

  /// Emulates the init() function of a cubit/bloc: seeds and loads the list
  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    final service = ref.read(bookServiceProvider);

    // Seed with a set of books (homework asked to fill in books in init())
    await service.seedBooks([
      Book(
        id: '1',
        title: '1984',
        author: 'George Orwell',
        description: 'Dystopian novel about surveillance and totalitarianism.',
        imageUrl: '', // optionally use asset or network link
      ),
      Book(
        id: '2',
        title: 'Brave New World',
        author: 'Aldous Huxley',
        description: 'Dystopian novel exploring conditioning and control.',
        imageUrl: '',
      ),
      Book(
        id: '3',
        title: 'Sapiens',
        author: 'Yuval Noah Harari',
        description: 'A brief history of humankind.',
        imageUrl: '',
      ),
      Book(
        id: '4',
        title: 'Clean Code',
        author: 'Robert C. Martin',
        description: 'A handbook of agile software craftsmanship.',
        imageUrl: '',
      ),
    ]);

    final list = await service.fetchBooks();
    final sorted = _sortList(list, state.sortBy);
    state = state.copyWith(books: sorted, isLoading: false);
  }

  /// Sorting helper
  List<Book> _sortList(List<Book> input, SortBy by) {
    final copy = List<Book>.from(input);
    if (by == SortBy.author) {
      copy.sort((a, b) => a.author.toLowerCase().compareTo(b.author.toLowerCase()));
    } else {
      copy.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
    return copy;
  }

  /// Change sort option and re-emit sorted list
  Future<void> setSortBy(SortBy newSort) async {
    if (newSort == state.sortBy) return; // nothing to do
    state = state.copyWith(isLoading: true);
    final sorted = _sortList(state.books, newSort);
    // emulate a small processing delay to show the shimmer/wait behavior if desired
    await Future.delayed(const Duration(milliseconds: 200));
    state = state.copyWith(books: sorted, sortBy: newSort, isLoading: false);
  }

  /// Select a book (navigating to detail uses this)
  void selectBook(Book book) {
    state = state.copyWith(selectedBook: book);
  }

  /// Called by the detail page leading button to go back to list view
  void backToList() {
    state = state.copyWith(selectedBook: null);
  }

  /// Add a book (keeps sorted order)
  Future<void> addBook(Book book) async {
    state = state.copyWith(isLoading: true);
    final service = ref.read(bookServiceProvider);
    await service.addBook(book);
    final updated = List<Book>.from(state.books)..add(book);
    final sorted = _sortList(updated, state.sortBy);
    state = state.copyWith(books: sorted, isLoading: false);
  }

  /// Delete a book (keeps sorted order)
  Future<void> deleteBook(String id) async {
    state = state.copyWith(isLoading: true);
    final service = ref.read(bookServiceProvider);
    await service.deleteBook(id);
    final updated = state.books.where((b) => b.id != id).toList();
    final sorted = _sortList(updated, state.sortBy);
    state = state.copyWith(books: sorted, isLoading: false);
  }
}
