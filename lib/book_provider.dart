import 'package:flutter/material.dart';
import 'package:library_app/book.dart';
import 'package:library_app/database_helper.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  List<Book> _cartBooks = [];
  List<Book> _libraryBooks = [];

  List<Book> get books => _filteredBooks.isNotEmpty ? _filteredBooks : _books;
  List<Book> get cartBooks => _cartBooks;
  List<Book> get libraryBooks => _libraryBooks;

  get cart => null;

  Future<void> fetchBooks() async {
    _books = await DatabaseService().books();
    _filteredBooks = [];
    notifyListeners();
  }

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void updateBook(String title, String author, Book updatedBook) {
    final index = _books.indexWhere((b) => b.author == author && b.title == title);
    if (index != -1) {
      _books[index] = updatedBook;
      notifyListeners(); // Notify listeners of the change
    }
  }

  void deleteBook(String title, String author) {
    _books.removeWhere((b) => b.title == title && b.author == author);
    notifyListeners(); // Notify listeners of the change
  }

  void sortBooksByTitle() {
    _books.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  void sortBooksByRating() {
    _books.sort((a, b) => a.rating.compareTo(b.rating)); // Ascending order
    notifyListeners();
  }

  void searchBooks(String query) {
    if (query.isEmpty) {
      _filteredBooks = [];
    } else {
      _filteredBooks = _books.where((book) => book.title.toLowerCase().contains(query.toLowerCase())).toList();
    }
    notifyListeners();
  }

  void addToCart(Book book) {
    if (!_cartBooks.contains(book)) {
      _cartBooks.add(book);
      notifyListeners();
    }
  }

  void removeFromCart(Book book) {
    _cartBooks.remove(book);
    notifyListeners();
  }

  void checkout() {
    _libraryBooks.addAll(_cartBooks);
    _cartBooks.clear();
    notifyListeners();
  }
}
