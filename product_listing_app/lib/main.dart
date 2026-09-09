import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/product_api.dart';
import 'logic/cart_cubit.dart';
import 'logic/product_cubit.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProductListingApp());
}

class ProductListingApp extends StatelessWidget {
  const ProductListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductCubit(ProductApi())..loadProducts()),
        BlocProvider(create: (_) => CartCubit()),
      ],
      child: MaterialApp(
        title: 'Shoply',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F8FC),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
