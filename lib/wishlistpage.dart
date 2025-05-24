import 'package:flutter/material.dart';
import 'product.dart';

class WishlistPage extends StatelessWidget {
  final List<Product> lovedProducts;
  const WishlistPage({super.key, required this.lovedProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: lovedProducts.isEmpty
          ? const Center(child: Text('No items in wishlist'))
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: lovedProducts.length,
        itemBuilder: (context, index) {
          final product = lovedProducts[index];
          return Card(
            elevation: 2,
            child: Column(
              children: [
                Expanded(
                  child: Image.network(product.image, fit: BoxFit.contain),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '\$${product.price}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
