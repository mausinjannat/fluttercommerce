import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'logIn.dart';
import 'signUp.dart';
import 'HomePage.dart';
import 'product.dart';
import 'wishlistpage.dart';

List<Product> lovedProducts = []; // Shared wishlist

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Set your actual starting screen here
      onGenerateRoute: (settings) {
        if (settings.name == '/wishlist') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          final List<Product> wishlist = (args['lovedProducts'] as List<dynamic>?)
              ?.cast<Product>() ??
              lovedProducts;

          return MaterialPageRoute(
            builder: (context) => WishlistPage(lovedProducts: wishlist),
          );
        } else if (settings.name == '/home') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          final String username = args['username'] ?? 'User';

          return MaterialPageRoute(
            builder: (context) => HomePage(
              username: username,
              lovedProducts: lovedProducts,
              onWishlistAdd: (product) {
                if (!lovedProducts.any((p) => p.id == product.id)) {
                  lovedProducts.add(product);
                }
              },
            ),
          );
        }
        return null;
      },
      routes: {

        '/login': (context) => const logIn(),
        '/signup': (context) => const signUp(),
      },
    );
  }
}
