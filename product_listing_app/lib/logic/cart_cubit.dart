import 'package:flutter_bloc/flutter_bloc.dart';

class CartState {
  const CartState(this.items);

  final Map<int, int> items;

  int get count => items.values.fold(0, (total, quantity) => total + quantity);
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState({}));

  bool add(int productId) {
    if (state.items.containsKey(productId)) {
      return false;
    }
    emit(CartState({
      ...state.items,
      productId: 1,
    }));
    return true;
  }
}
