import 'dart:io';
import 'package:flutter/material.dart';
import 'package:library_app/add_book_screen.dart';
import 'package:library_app/book.dart';
import 'package:library_app/book_provider.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late Book _book;

  @override
  void initState() {
    super.initState();
    _book = widget.book;

    // Mark the book as read if it is not already marked
    if (!_book.isRead) {
      setState(() {
        _book = Book(
          id: _book.id,
          title: _book.title,
          author: _book.author,
          description: _book.description,
          rating: _book.rating,
          isRead: true,
          price: _book.price,
          filePath: _book.filePath,
          imageUrl: _book.imageUrl,
        );
      });

      // Update the book status in the provider
      Provider.of<BookProvider>(context, listen: false).updateBook(_book.title, _book.author, _book);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedBook = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditBookScreen(book: _book),
                ),
              );

              if (updatedBook != null) {
                setState(() {
                  _book = updatedBook; // Update the book with the returned data
                  // Update the book details in the provider
                  Provider.of<BookProvider>(context, listen: false).updateBook(_book.title, _book.author, _book);
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final bool? deleteConfirmed = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this book?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (deleteConfirmed == true) {
                Provider.of<BookProvider>(context, listen: false).deleteBook(_book.title, _book.author);
                Navigator.of(context).popUntil((route) => route.isFirst); // Ensure it pops to the first route which is HomeScreen
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _book.filePath.isEmpty
                ? const Text('No image available')
                : Container(
                    width: 150, // Set the width of the image
                    height: 200, // Set the height of the image
                    child: Image.file(
                      File(_book.filePath),
                      fit: BoxFit.cover, // Adjust the fit property to control how the image scales
                    ),
                  ),
            const SizedBox(height: 8),
            Text('Author: ${_book.author}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Rating: ${_book.rating}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Price: \$${_book.price}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Description: ${_book.description}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Read: ${_book.isRead ? 'Yes' : 'No'}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
