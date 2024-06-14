import 'package:flutter/cupertino.dart';

import '../models/cart.dart';
import '../repositories/interfaces/cart_service_interface.dart';

class CartViewModel extends ChangeNotifier{
  List<String>? listProductId;

  Cart? cart;

  ICartService service;

  CartViewModel(this.service);

  Future<void> getCart() async{
    cart = await service.getCart();
    notifyListeners();
  }

  CartItem getCartItemFromViewModel(CartItemViewModel item){
    return CartItem(id: item.id, quantity: item.quantity);
  }

  Future<void> getProductInCart() async{
    listProductId = await service.getProductInCart();
    notifyListeners();
  }

  Future<void> addProductToCart(CartItemViewModel itemViewModel) async{
    CartItem item = getCartItemFromViewModel(itemViewModel);
    await service.addProductToCart(item);
    notifyListeners();
  }

  Future<void> removeProductFromCart(String productId) async{
    await service.removeProductFormCart(productId);
    notifyListeners();
  }

}

class CartItemViewModel{
  String id = '';
  int quantity = 0;

  CartItemViewModel({required this.id, required this.quantity});
}