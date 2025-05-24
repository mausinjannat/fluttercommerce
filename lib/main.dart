import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'logIn.dart';
import 'signUp.dart';
import 'HomePage.dart';
import 'product.dart';
import 'wishlistpage.dart';

List<Product> lovedProducts = [];

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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
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
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}

// ---------------- Splash Screen ----------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/logo1.jpg', fit: BoxFit.cover),
          Center(
            child: Text(
              'SHOPIFY',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Onboarding Screen ----------------
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Purchase Online",
     "desc": "Purchase your product setting inside the room",
      "image": "assets/purchase.jpg"
    },
    {
      "title": "Pay",
      "desc": "Easy and secure payment at your fingertips.",
      "image": "assets/pay.jpg"
    },
    {
      "title": "Delivery",
      "desc": "Fast delivery with real-time tracking.",
      "image": "assets/delivery.jpg"
    },
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < onboardingData.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });
  }

  void _onDone() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        physics: const NeverScrollableScrollPhysics(), // Prevent manual swipe
        itemBuilder: (context, index) => OnboardingPage(
          title: onboardingData[index]['title']!,
          desc: onboardingData[index]['desc']!,
          image: onboardingData[index]['image']!,
          isLast: index == onboardingData.length - 1,
          onContinue: _onDone,
        ),
      ),
    );
  }
}

// ---------------- Onboarding Page Widget ----------------
class OnboardingPage extends StatelessWidget {
  final String title;
  final String desc;
  final String image;
  final bool isLast;
  final VoidCallback onContinue;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.desc,
    required this.image,
    required this.isLast,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (isLast)
                  ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Continue'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
