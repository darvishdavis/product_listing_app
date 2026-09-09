import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/cart_cubit.dart';
import '../logic/product_cubit.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            const SliverToBoxAdapter(child: _SearchAndCategories()),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state.status == ProductStatus.loading ||
                    state.status == ProductStatus.initial) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.status == ProductStatus.failure) {
                  return SliverFillRemaining(
                    child: _MessageState(
                      icon: Icons.cloud_off_outlined,
                      message: state.errorMessage ?? 'Something went wrong.',
                      action: 'Retry',
                      onAction: context.read<ProductCubit>().loadProducts,
                    ),
                  );
                }
                if (state.visibleProducts.isEmpty) {
                  return const SliverFillRemaining(
                    child: _MessageState(
                      icon: Icons.search_off_rounded,
                      message: 'No products match your search.',
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = state.visibleProducts[index];
                        return ProductCard(
                          product: product,
                          isFavorite: state.favorites.contains(product.id),
                          onFavorite: () => context
                              .read<ProductCubit>()
                              .toggleFavorite(product.id),
                          onAddToCart: () {
                            final wasAdded =
                                context.read<CartCubit>().add(product.id);
                            if (wasAdded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to cart')),
                              );
                            }
                          },
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(product: product),
                            ),
                          ),
                        );
                      },
                      childCount: state.visibleProducts.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: .62,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFFE8E5FF),
            child: Icon(Icons.person, color: Color(0xFF5148D8), size: 30),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning,', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 2),
                Text('Discover something new',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) => Badge(
              isLabelVisible: state.count > 0,
              label: Text('${state.count}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndCategories extends StatelessWidget {
  const _SearchAndCategories();

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'men clothing',
      'women clothing',
      'jewelery',
      'electronics',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          TextField(
            onChanged: context.read<ProductCubit>().updateQuery,
            decoration: InputDecoration(
              hintText: 'Search products',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 38,
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final category = categories[index];
                  final selected = state.category == category;
                  return ChoiceChip(
                    label: Text(
                      category == 'All' ? 'All' : _prettyCategory(category),
                    ),
                    selected: selected,
                    onSelected: (_) =>
                        context.read<ProductCubit>().selectCategory(category),
                    selectedColor: const Color(0xFF6C63FF),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Most Popular',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  String _prettyCategory(String value) => value
      .split(' ')
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.grey),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: 14),
              FilledButton(onPressed: onAction, child: Text(action!)),
            ],
          ],
        ),
      ),
    );
  }
}
