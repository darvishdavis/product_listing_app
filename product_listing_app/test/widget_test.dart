import 'package:flutter_test/flutter_test.dart';
import 'package:product_listing_app/main.dart';

void main() {
  testWidgets('renders the product app shell', (tester) async {
    await tester.pumpWidget(const ProductListingApp());

    expect(find.text('Discover something new'), findsOneWidget);
    expect(find.byType(ProductListingApp), findsOneWidget);
  });
}
