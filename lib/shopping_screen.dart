import 'package:flutter/material.dart';
import 'package:library_app/book.dart';
import 'package:library_app/cart_screen.dart';

class ShoppingScreen extends StatefulWidget {
  final List<Book> books; // Pass the list of books to this screen

  ShoppingScreen({required this.books});

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<Book> cart = []; // List to store cart items

  void _toggleCart(Book book) {
    setState(() {
      if (book.isInCart) {
        cart.removeWhere((b) => b.id == book.id);
      } else {
        cart.add(book);
      }
      // Updating the state of the book is not ideal, better use a different mechanism to handle this
    });
  }

  void _viewCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cart: cart, onCheckout: (List<Book> checkoutBooks) {  },),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _viewCart, // View cart contents
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.books.length,
        itemBuilder: (context, index) {
          final book = widget.books[index];
          return ListTile(
            contentPadding: EdgeInsets.all(16.0),
            leading: Icon(Icons.book, color: Colors.blue), // Placeholder for book icon
            title: Text(book.title),
            subtitle: Text('${book.author} - \$${book.price.toStringAsFixed(2)}'), // Display book price
            trailing: IconButton(
              icon: Icon(
                cart.any((b) => b.id == book.id) ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                color: cart.any((b) => b.id == book.id) ? Colors.red : Colors.green,
              ),
              onPressed: () => _toggleCart(book),
            ),
          );
        },
      ),
    );
  }
}
