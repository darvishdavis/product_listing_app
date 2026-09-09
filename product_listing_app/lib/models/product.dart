class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] as Map<String, dynamic>? ?? {};
    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? 'Untitled product',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String? ?? 'Other',
      description: json['description'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      rating: (rating['rate'] as num?)?.toDouble() ?? 0,
      reviewCount: (rating['count'] as num?)?.toInt() ?? 0,
    );
  }

  final int id;
  final String title;
  final double price;
  final String category;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
}
