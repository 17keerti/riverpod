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
    Book? selectedBook, 
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

/// Notifier 
class BooksNotifier extends StateNotifier<BooksState> {
  final Ref ref;
  BooksNotifier(this.ref) : super(BooksState.initial()) {
    init();
  }

  /// init() function
  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    final service = ref.read(bookServiceProvider);

    // Seed with a set of books
    await service.seedBooks([
      Book(
        id: '1',
        title: 'Carmilla Grit',
        author: 'Susan Dene Herbers',
        imageUrl: 'assets/charmer.png',
        description: 'A dark tale of courage and discovery in a mythical world.',
      ),
      Book(
        id: '2',
        title: 'little gods',
        author: 'Meng Jin',
        imageUrl: 'assets/littleGods.png',
        description: 'An expansive and intimate novel exploring motherhood, migration, and the Chinese diaspora.',
      ),
      Book(
        id: '3',
        title: 'A Clockwork Orange',
        author: 'Anthony Burgess',
        imageUrl: 'assets/clockwork.png',
        description: 'A disturbing yet thought-provoking look at the nature of morality and free will.',
      ),
      Book(
        id: '4',
        title: 'The Memory of Water',
        author: 'Emmi Itäranta',
        imageUrl: 'assets/memory.png',
        description: 'In a world ravaged by environmental disaster, a young woman guards a dangerous secret.',
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
    if (newSort == state.sortBy) return; 
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
}