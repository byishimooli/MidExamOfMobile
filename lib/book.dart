class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final double rating;
  final bool isRead;
  final double price;
  final String filePath;
  final String imageUrl; // Add this property
  bool isInCart;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.rating,
    required this.isRead,
    required this.price,
    required this.filePath,
    required this.imageUrl, // Add this to the constructor
    this.isInCart = false, // Default value
  });

  // Convert a Book into a Map. The keys must match the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'rating': rating,
      'isRead': isRead ? 1 : 0, // SQLite expects integers for boolean values
      'price': price,
      'filePath': filePath,
      'imageUrl': imageUrl, // Add this line for SQLite
      'isInCart': isInCart ? 1 : 0, // Add this line for SQLite
    };
  }

  // Create a Book object from a Map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      description: map['description'],
      rating: map['rating'],
      isRead: map['isRead'] == 1, // Convert back to boolean
      price: map['price'],
      filePath: map['filePath'],
      imageUrl: map['imageUrl'], // Add this line for SQLite
      isInCart: map['isInCart'] == 1, // Convert back to boolean
    );
  }
}
