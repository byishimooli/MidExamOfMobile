import 'package:flutter/material.dart';
import 'package:library_app/add_book_screen.dart';
import 'package:library_app/book.dart';

class LibraryScreen extends StatelessWidget {
  final List<Book> initialBooks;
  final Function(Book) onAddBook;

  LibraryScreen({required this.initialBooks, required this.onAddBook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: ListView.builder(
        itemCount: initialBooks.length,
        itemBuilder: (context, index) {
          final book = initialBooks[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: Text('\$${book.price.toStringAsFixed(2)}'),
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
            onAddBook(newBook);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
