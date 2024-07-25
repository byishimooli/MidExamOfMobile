import 'package:flutter/material.dart';
import 'package:library_app/book.dart';

class CartScreen extends StatelessWidget {
  final List<Book> cart;
  final Function(List<Book>) onCheckout;

  CartScreen({required this.cart, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final book = cart[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: Text('\$${book.price.toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                onCheckout(cart);
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
