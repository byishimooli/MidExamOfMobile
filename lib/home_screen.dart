import 'dart:io';
import 'package:flutter/material.dart';
import 'package:library_app/add_book_screen.dart';
import 'package:provider/provider.dart';
import 'package:library_app/book.dart';
import 'package:library_app/cart_screen.dart';
import 'package:library_app/library_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details_book_screen.dart';
import 'book_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _sortingPreference = 'title';

  @override
  void initState() {
    super.initState();
    _loadSortingPreference();
  }

  Future<void> _loadSortingPreference() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _sortingPreference = preferences.getString('sorting_preference') ?? 'title';
    });
  }

  Future<void> _saveSortingPreference(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('sorting_preference', value);
    setState(() {
      _sortingPreference = value;
    });
  }

  void _sortBooks(List<Book> books) {
    if (_sortingPreference == 'title') {
      books.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortingPreference == 'author') {
      books.sort((a, b) => a.author.compareTo(b.author));
    } else if (_sortingPreference == 'rating') {
      books.sort((a, b) => a.rating.compareTo(b.rating));
    }
  }

  void _onBookUpdated(Book updatedBook) {
    setState(() {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      final index = bookProvider.books.indexWhere((b) => b.id == updatedBook.id);
      if (index != -1) {
        bookProvider.books[index] = updatedBook;
        _sortBooks(bookProvider.books);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: BookSearchDelegate());
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: Colors.white),
            onSelected: (String value) {
              _saveSortingPreference(value);
            },
            itemBuilder: (BuildContext context) {
              return {'title', 'author', 'rating'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice[0].toUpperCase() + choice.substring(1)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          final books = List<Book>.from(bookProvider.books);
          _sortBooks(books);

          return GridView.builder(
            padding: const EdgeInsets.all(5.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                elevation: 4.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final updatedBook = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsScreen(book: book),
                          ),
                        );

                        if (updatedBook != null) {
                          _onBookUpdated(updatedBook);
                        }
                      },
                      child: book.filePath.isEmpty
                          ? Container(
                              color: Colors.grey[100],
                              height: 0,
                              child: Center(child: Text('No image')),
                            )
                          : Image.file(
                              File(book.filePath),
                              height: 90,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            book.author,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '\$${book.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.blue),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    ButtonBar(
                      children: [
                        IconButton(
                          icon: Icon(
                            book.isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                            color: book.isInCart ? Colors.red : Colors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              if (book.isInCart) {
                                Provider.of<BookProvider>(context, listen: false).removeFromCart(book);
                                book.isInCart = false;
                              } else {
                                Provider.of<BookProvider>(context, listen: false).addToCart(book);
                                book.isInCart = true;
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.info, color: Colors.blue),
                          onPressed: () async {
                            final updatedBook = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsScreen(book: book),
                              ),
                            );

                            if (updatedBook != null) {
                              _onBookUpdated(updatedBook);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBook = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditBookScreen()),
          );
          if (newBook != null) {
            Provider.of<BookProvider>(context, listen: false).addBook(newBook);
          }
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 1, 30, 54),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.library_books, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LibraryScreen(initialBooks: [], onAddBook: (Book book) {}),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(context: context, delegate: BookSearchDelegate());
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                final cart = Provider.of<BookProvider>(context, listen: false).cart;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      cart: cart,
                      onCheckout: (List<Book> books) {
                        // Implement your checkout logic here
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate<Book?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final results = bookProvider.books.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView(
      children: results.map((book) {
        return ListTile(
          leading: book.filePath.isEmpty
              ? Container(
                  color: Colors.grey[100],
                  height: 50,
                  width: 50,
                  child: Center(child: Text('No image')),
                )
              : Image.file(
                  File(book.filePath),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            close(context, book);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search for books'),
    );
  }
}
