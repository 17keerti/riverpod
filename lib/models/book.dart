class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl; // could be local asset or network url

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.description = '',
    this.imageUrl = '',
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? imageUrl,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
