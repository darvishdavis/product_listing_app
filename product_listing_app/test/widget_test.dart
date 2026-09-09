import 'package:flutter_test/flutter_test.dart';
import 'package:product_listing_app/main.dart';
import 'package:product_listing_app/logic/cart_cubit.dart';

void main() {
  testWidgets('renders the product app shell', (tester) async {
    await tester.pumpWidget(const ProductListingApp());

    expect(find.text('Discover something new'), findsOneWidget);
    expect(find.byType(ProductListingApp), findsOneWidget);
  });

  test('only counts each product once in the cart', () {
    final cart = CartCubit();

    cart.add(1);
    final duplicateAdded = cart.add(1);
    final secondProductAdded = cart.add(2);

    expect(cart.state.count, 2);
    expect(cart.state.items, {1: 1, 2: 1});
    expect(duplicateAdded, isFalse);
    expect(secondProductAdded, isTrue);
    cart.close();
  });
}
