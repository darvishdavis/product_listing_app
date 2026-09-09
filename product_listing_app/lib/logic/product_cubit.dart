import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_api.dart';
import '../models/product.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.query = '',
    this.category = 'All',
    this.favorites = const {},
    this.errorMessage,
  });

  final ProductStatus status;
  final List<Product> products;
  final String query;
  final String category;
  final Set<int> favorites;
  final String? errorMessage;

  List<Product> get visibleProducts {
    final normalizedQuery = query.trim().toLowerCase();
    return products.where((product) {
      final matchesQuery = normalizedQuery.isEmpty ||
          product.title.toLowerCase().contains(normalizedQuery);
      final matchesCategory = category == 'All' || product.category == category;
      return matchesQuery && matchesCategory;
    }).toList(growable: false);
  }

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? query,
    String? category,
    Set<int>? favorites,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      query: query ?? this.query,
      category: category ?? this.category,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage,
    );
  }
}

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this._api) : super(const ProductState());

  final ProductApi _api;

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductStatus.loading, errorMessage: null));
    try {
      final products = await _api.fetchProducts();
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (_) {
      emit(state.copyWith(
        status: ProductStatus.failure,
        errorMessage:
            'We could not load the products. Check your connection and try again.',
      ));
    }
  }

  void updateQuery(String query) => emit(state.copyWith(query: query));

  void selectCategory(String category) =>
      emit(state.copyWith(category: category));

  void toggleFavorite(int productId) {
    final favorites = {...state.favorites};
    if (!favorites.add(productId)) {
      favorites.remove(productId);
    }
    emit(state.copyWith(favorites: favorites));
  }
}
