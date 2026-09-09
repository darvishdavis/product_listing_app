import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductApi {
  ProductApi({http.Client? client}) : _client = client ?? http.Client();

  static final _endpoint = Uri.parse('https://fakestoreapi.com/products');
  final http.Client _client;

  Future<List<Product>> fetchProducts() async {
    final response = await _client.get(_endpoint).timeout(
          const Duration(seconds: 15),
        );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to load products (${response.statusCode}).');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('The products response was invalid.');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList(growable: false);
  }
}
