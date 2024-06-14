import 'package:shopping_app/models/cart.dart';
import 'package:shopping_app/repositories/interfaces/cart_interface.dart';

import '../repositories/interfaces/cart_service_interface.dart';

class CartService extends ICartService{

  final ICartRepository repository;

  CartService(this.repository);

  @override
  Future<List<String>> getProductInCart() async{
    return await repository.getProductsInCart();
  }

  @override
  Future<void> addProductToCart(CartItem item) async{
    await repository.addProductToCart(item);
  }


  @override
  Future<void> removeProductFormCart(String productId) async {
    await repository.removeProductFromCart(productId);
  }

  @override
  Future<Cart> getCart() async{
    return await repository.getCart();
  }


}