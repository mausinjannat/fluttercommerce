class Product {
  final int id;
  final String title;
  final String image;
  final double price;
  bool isLoved;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.isLoved = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      isLoved: json['isLoved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'isLoved': isLoved,
    };
  }
}
