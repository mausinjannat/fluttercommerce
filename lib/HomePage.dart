import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class HomePage extends StatefulWidget {
  final String username;
  final List<Product> lovedProducts;
  final Function(Product) onWishlistAdd;

  const HomePage({
    super.key,
    required this.username,
    required this.lovedProducts,
    required this.onWishlistAdd,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _futureProducts;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<Product> products = data.map((item) => Product.fromJson(item)).toList();
      _allProducts = products;
      _filteredProducts = products;
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToCart(BuildContext context) {
    Navigator.pushNamed(context, '/cart');
  }

  void _goToWishlist(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/wishlist',
      arguments: {'lovedProducts': widget.lovedProducts},
    );
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu),
          onSelected: (value) {
            if (value == 'cart') _goToCart(context);
            if (value == 'wishlist') _goToWishlist(context);
            if (value == 'logout') _logout(context);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'cart', child: Text('🛒 Cart')),
            const PopupMenuItem(value: 'wishlist', child: Text('Wishlist')),
            const PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome, ${widget.username}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterProducts,
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Categories', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      children: _filteredProducts.map((product) {
                        return ProductItem(
                          product: product,
                          onLoveTap: () {
                            setState(() {
                              product.isLoved = !product.isLoved;
                            });
                            if (product.isLoved) {
                              widget.onWishlistAdd?.call(product); // ✅ safe call
                            }
                          },
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onLoveTap;

  const ProductItem({super.key, required this.product, required this.onLoveTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(product.image, fit: BoxFit.contain),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: product.isLoved ? Colors.red : Colors.grey,
                    ),
                    onPressed: onLoveTap,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '\$${product.price.toString()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
