import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/cart_cubit.dart';
import '../models/product.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Badge(
                isLabelVisible: state.count > 0,
                label: Text('${state.count}'),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported_outlined, size: 64),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            product.category.toUpperCase(),
            style: const TextStyle(
                color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(product.title,
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFB300)),
              const SizedBox(width: 4),
              Text(
                  '${product.rating.toStringAsFixed(1)}  (${product.reviewCount} reviews)'),
              const Spacer(),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('About this product',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(product.description,
              style: const TextStyle(height: 1.5, color: Colors.black54)),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () {
              context.read<CartCubit>().add(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to cart')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to cart'),
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ],
      ),
    );
  }
}
